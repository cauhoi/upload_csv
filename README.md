### Upload CSV


This is a Rails app that accepts file
uploads, stores the data in a relational database, and displays the information
back to the user.

- Built in Ruby on Rails.
- Allow a user to upload a comma-delimited file of contacts via a web form. The
  file will contain the following columns: `first_name`, `last_name`, `email_address`,
  `phone_number`, `company_name`. There's an example file included (data.csv).
- Parse the given file, normalize the data, and store the information in a
  relational database.
- Display the list of contacts and their data.
- Allow deleting specific contacts via Ajax.
- Allow the list of contacts to be filtered via Javascript to show:
  - Only contacts with `.com` email addresses
  - Order the contacts alphabetically by email address

## Running Test
```
rails test test/controllers/users_controller_test.rb
rails test test/models/user_test.rb 
```
