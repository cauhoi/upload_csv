require_relative 'card'
require 'minitest/autorun'

class CardTest < Minitest::Test

  # test for deck empty should not pick, or deal
  # test for deck is full, should not add
  # test for Card invalid
  # test for add, deal, pick,shuffle, and putback cards should return complete deck
  # test find card
  # test for deal & shuffle mechanism shuffle when less than 52
  # check for the variable @dealt-cards, added_card, and picked card
  # card method show, suit_to_s

  def test_should_find_card_in_deck
    assert_equal 3, @deck.find_card(@card)
  end

  def test_should_not_find_card_in_deck
    card = @deck.deal
    refute @deck.find_card(card)
    card2 = @deck.pick_a_card
    refute @deck.find_card(card2)
  end

  def test_should_return_a_complete_deck_when_putting_back_cards
    assert @deck.is_complete?
    @deck.deal
    @deck.deal
    @deck.pick_a_card
    @deck.shuffle_it
    card = @deck.deal
    @deck.add_a_card(card)
    refute @deck.is_complete?
    @deck.put_back_cards
    assert @deck.is_complete?
  end

  def test_deal
    @deck.shuffle_it
    card = @deck.deal
    card2 = @deck.deal
    assert_equal card.value, @deck.dealt_cards.first.value
    assert_equal card.suit.value, @deck.dealt_cards.first.suit.value
    assert_equal card2.value, @deck.dealt_cards.last.value
    assert_equal card2.suit.value, @deck.dealt_cards.last.suit.value
    assert_equal 50,@deck.my_deck.length
  end

  def test_pick_a_card
    @deck.shuffle_it
    @deck.deal
    card = @deck.pick_a_card
    assert_equal 1,@deck.picked_cards.length
    assert_equal card.value, @deck.picked_cards.last.value
    assert_equal card.suit.value, @deck.picked_cards.last.suit.value
    refute @deck.find_card(card)
  end

  def test_add_a_card
    assert @empty_deck.empty?
    @empty_deck.add_a_card(@card)
    assert_equal @card.value, @empty_deck.my_deck.last.value
    assert_equal @card.suit.value, @empty_deck.my_deck.last.suit.value
    assert_equal 1,@empty_deck.cards_left
    refute @empty_deck.add_a_card(@card)
    assert_equal 1,@empty_deck.cards_left
    assert_equal @card.value, @empty_deck.added_cards.last.value
    assert_equal @card.suit.value, @empty_deck.added_cards.last.suit.value

    card2 = Card.new(13,0)
    index = @empty_deck.add_a_card(card2)
    assert_equal 2,@empty_deck.cards_left
    assert_equal card2.value, @empty_deck.my_deck[index].value
    assert_equal card2.suit.value, @empty_deck.my_deck[index].suit.value

  end

  def test_shuffle
    first_card = @deck.my_deck.first
    last_card = @deck.my_deck.last
    @deck.shuffle_it
    refute_equal first_card.value, @deck.my_deck.first.value
    refute_equal last_card.value, @deck.my_deck.last.value
  end


  def test_should_not_deal_shuffle_or_pick_a_card_from_empty_deck
    @deck.cards_left.times{@deck.deal}
    assert @deck.empty?
    assert_raises do
      @deck.deal
    end
    assert_raises do
      @deck.shuffle_it
    end
    assert_raises do
      @deck.pick_a_card
    end

  end

  def test_should_not_allow_to_add_card_when_deck_is_full
    assert @deck.is_full?
    refute @deck.add_a_card(@card)
  end

  def test_card_should_be_valid_when_created
    exception = assert_raises ArgumentError do
      bad_card = Card.new(14,2)
    end
  assert_equal("Card value is not valid", exception.message)
  exception = assert_raises ArgumentError do
      bad_card = Card.new(19,5)
    end
  assert_equal("Suit value is not valid", exception.message)

  end

  def test_should_display_card_value_and_suit
    card = Card.new(1,3)
    assert_equal "Ace", card.value_to_s
    assert_equal "Ace of Hearts", card.show
    card = Card.new(11,0)
    assert_equal "Jack", card.value_to_s
    assert_equal "Jack of Spades", card.show
  end


  def setup
    @deck = CardDeck.new
    @card = Card.new(1,3)
    @empty_deck = CardDeck.new
    @empty_deck.cards_left.times{@empty_deck.deal}

  end


end