require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get "/users"
    assert_response :success

  end

  test "should parse csv into array of hash" do
    file_csv = fixture_file_upload 'data.csv'
    value_hash_arr = UsersController.new.load_from_csv(file_csv)
    assert_equal 200, value_hash_arr.length
    assert_equal "Gerhard",value_hash_arr[0][:first_name]
    assert_equal "gerhardkautzer@cronabayer.com",value_hash_arr[0][:email_address]
  end


  test "should display error when uploading csv containing invalid user data" do
    get users_bulk_upload_path
    assert_response :success

    csv_file = Tempfile.new('users.csv')
    csv_file.write <<CSV
First Name,Last Name,Email Address,Phone Number,Company Name
Gerhard,Kautzer,,1-207-643-1816,my-company
Myra2,Crona,test@c.com,(724)196-9470 x998,
Josh,Donnelly,sameemail@c.com,081-799-3139 x248,ABC store
Verna,Farrell,sameemail@c.com,731.101.6219,Rosenbaum-Hane
CSV
    csv_file.rewind

    file =  Rack::Test::UploadedFile.new(csv_file.path, 'text/csv')
    assert_difference 'User.count', 1 do
      post users_upload_path, params: {:user_csv => file}
    end

    assert_equal "sameemail@c.com", User.last.email_address
    assert_not_equal "Verna", User.last.first_name
    assert_response :redirect
    assert_redirected_to users_bulk_upload_path
    assert flash[:error].present?

    csv_file.close
    csv_file.unlink
  end

  test "should import all users in the data csv" do
    User.all.delete_all

    file_csv = fixture_file_upload 'data.csv'
    assert_difference 'User.count', 200 do
      post users_upload_path, params: {:user_csv => file_csv}
    end
    assert_response :redirect
    assert_redirected_to users_bulk_upload_path
    assert flash[:success].present?
    assert_equal "Users were successfully imported", flash[:success]

  end

end
