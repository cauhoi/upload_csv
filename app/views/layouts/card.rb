class Suit
  SPADES = 0
  CLUBS = 1
  DIAMONDS = 2
  HEARTS = 3

  VALID_SUIT = [SPADES,CLUBS,DIAMONDS,HEARTS]


  def initialize(v)
    @val = v
    validate_suit
  end

  def value
    @val
  end

  def suit_to_s
    case @val
      when SPADES
        "Spades"
      when CLUBS
        "Clubs"
      when DIAMONDS
        "Diamonds"
      when HEARTS
        "Hearts"
    end
  end

  private
  def validate_suit
    if VALID_SUIT.include?(@val)
      return true
    else
      raise ArgumentError.new("Suit value is not valid")
    end

  end

end

class Card

  ACE = 1
  JACK =11
  QUEEN =12
  KING =13

  # VALID_SUITS = [SPADES,CLUBS,DIAMONDS,HEARTS]
  VALID_VALUES = [2,3,4,5,6,7,8,9,10,JACK,QUEEN,KING,ACE]

  # this is the facevalue and suit of the card
  attr_reader :value,:suit

  def initialize(value, s)
    @value = value
    # @suit = suit
    @suit = Suit.new(s)
    validation_check
  end

  # this returns the value of the card. Depends on the game, the get_value can return different value than
  # the facevalue
  def get_value
    @value
  end
  def get_suit
    @suit
  end


  def value_to_s
    case @value
      when ACE
        "Ace"
      when JACK
        "Jack"
      when QUEEN
        "Queen"
      when KING
        "King"
      else
        @value.to_s
    end

  end

  def show
    return "#{value_to_s} of #{@suit.suit_to_s}"
  end

  def is_face_card?
    if [JACK,QUEEN,KING].include?(@value)
      return true
    else
      return false
    end
  end

  def is_an_ace?
    return true if @value == ACE
  end

  private

  def validation_check
    if !VALID_VALUES.include?(@value)
      raise ArgumentError.new("Card value is not valid")
    end

  end

end

class CardDeck
  attr_reader :dealt_cards, :picked_cards, :added_cards

  def initialize
    @deck ||= []
    (1..13).each do |value|
        4.times do |suit|
          card = Card.new(value,suit)
          @deck << card
        end
    end
    @dealt_cards = []
    @picked_cards = []
    @added_cards = []
  end

  def my_deck
    @deck
  end

  def pick_a_card
    if cards_left > 0
      random = rand(cards_left)
      card = get_deck.delete_at(random)
      @picked_cards << card
      card
    end
  end

  def put_back_cards
    (@picked_cards + @dealt_cards).each do |x|
      if !find_card(x)
        @deck << x
      end
    end
    @dealt_cards = []
    @picked_cards = []
    @added_cards = []
    @deck
  end

  def empty?
    if @deck.length == 0
      return true
    else
      return false
    end
  end

  def is_full?
    return true if @deck.length >=52
  end

  # check to see if the deck has all 52 cards without duplicate
  def is_complete?
    if empty?
      puts "Deck is empty"
      return false
    elsif !is_full?
      puts "Deck is missing some cards"
      return false
    else
      myhash = {}
      @deck.each do |x|
        myhash[x.suit.value] ||= []
        myhash[x.suit.value] << x.value
      end

      Suit::VALID_SUIT.each do |suit|
        return false if myhash[suit].length != 13
      end
      return true

    end

  end

  # return the position that the card is inserted into
  # return false if deck is full or card exists in the deck

  def add_a_card(card)
    if is_full?
      puts "Deck is full.You can't add a card"
      return false
    elsif empty?
      @deck << card
      @added_cards << card
      cards_left
    elsif !find_card(card)
      random = rand(cards_left)
      insert_card(random, card)
      @added_cards << card
      random
    else
      puts "Can't add a duplicate card to the Deck"
      return false
    end
  end



  def shuffle_it
    cards_left.times do |i|
      random = rand(cards_left)
      temp = @deck[i]
      @deck[i] = @deck[random]
      @deck[random] = temp
    end
    get_deck
  end

  def deal
    card = get_deck.pop
    @dealt_cards << card
    card
  end

  def cards_left
    get_deck.length
  end

  def show
    result = []
    get_deck.each do |x|
      result << x.show
    end
    result
  end

  def find_card(card)
    if card_valid?(card)
      get_deck.each_with_index do |x,index|
        return index if (x.value == card.value) && (x.suit.value == card.suit.value)
      end
      return false
    end
  end


  private

  def card_valid?(card)
    if card.is_a? Card
      return true
    else
      raise "The argument is not a Card"
    end
  end

  def get_deck
    if @deck.empty? || @deck.nil?
      raise "Deck is empty"
    else
      @deck
    end
  end

  def insert_card(pos,card)
    @deck.insert(pos, card)
  end

  def remove_card_from_dealt_cards(card)
    if card_valid?(card)
      @dealt_cards.each_with_index do |x,index|
         if (x.value == card.value) && (x.suit.value == card.suit.value)
           @dealt_cards.delete_at(index)
           return index
         end
      end
    end
  end


end

class BlackJack < Card

  def get_value
    if is_face_card?
      return 10
    else
      return @value
    end
  end

end

class BlackJackDeck < CardDeck
  def initialize
    @deck = []
  end

end

deck = CardDeck.new

