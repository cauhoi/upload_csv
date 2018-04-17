class User < ApplicationRecord
  belongs_to :company
  validates_presence_of :email_address

  def self.create_user_from_hash(user_hash)
    error = nil
    begin
      fn = user_hash[:first_name]
      ln = user_hash[:last_name]
      email = user_hash[:email_address]
      phone = user_hash[:phone_number]
      company = user_hash[:company_name]
      User.transaction do

        if company.present? && (user_company = Company.find_or_create_by(name: company))
          if user = User.find_by(email_address: email)
            error = "User #{email} is already exists"
            Rails.logger.error(error)
          else
            User.create!(first_name: fn,last_name: ln, email_address: email, phone_number: phone, company_id: user_company.id)
            Rails.logger.info("User #{email} is imported")
          end
        else
          error = "Company Name Field is empty. User #{fn} is not created"
          Rails.logger.error(error)
        end
      end
      error
    rescue ActiveRecord::RecordInvalid => invalid
      error = "Error importing user #{fn} - " + invalid.record.errors.full_messages.first
    rescue  => e
      Rails.logger.error("Error create user #{fn} - email #{email}")
      error = "Error importing user #{email} #{e.message}"
      error
    end

  end
end
