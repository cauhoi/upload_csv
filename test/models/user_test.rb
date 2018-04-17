require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "user should not be created from hash if missing company_name or email address" do
    user_hash = {}
    assert_no_difference"User.count" do
      User.create_user_from_hash(user_hash)
    end

    user_hash = {first_name: "damien", last_name: "test", email_address: "", phone_number:"12345",company_name: "ABC Corp"}
    assert_no_difference "User.count" do
      User.create_user_from_hash(user_hash)
    end

    user_hash = {first_name: "damien", last_name: "test", email_address: "test+1@gmail.com", phone_number:"12345",company_name: nil}
    assert_no_difference "User.count" do
      User.create_user_from_hash(user_hash)
    end

  end
  test "user should be created when email and company_name are provided" do
    user_hash = {first_name: nil , last_name: nil, email_address: "test+1@gmail.com", phone_number: nil ,company_name: "Corp"}
    assert_difference "User.count",1 do
      User.create_user_from_hash(user_hash)
    end

    user_hash = {first_name: "test", last_name: "me", email_address: "test+2@gmail.com", phone_number: "1234" ,company_name: "Corp"}
    assert_difference "User.count",1 do
      User.create_user_from_hash(user_hash)
    end
    assert_equal "test",User.last.first_name
    assert_equal "test+2@gmail.com", User.last.email_address
    assert_equal "Corp", User.last.company.name

  end

  test "user should not be created when account is already existed" do
    user_hash = {first_name: "test", last_name: "me", email_address: "test+2@gmail.com", phone_number: "1234" ,company_name: "Corp"}
    assert_difference "User.count",1 do
      error = User.create_user_from_hash(user_hash)
      assert_nil error
    end
    user_hash = {first_name: "Different", last_name: "Name", email_address: "test+2@gmail.com", phone_number: "6666" ,company_name: "Corp"}
    assert_no_difference "User.count" do
      error = User.create_user_from_hash(user_hash)
      assert_not_nil error
      assert error.include?("User test+2@gmail.com is already exists")
    end

  end

end
