require 'csv'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def load_from_csv(filename)
    values_array = []

    begin
      CSV.foreach(filename.path, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        values_array << row.to_hash
      end
      values_array
    rescue => e
      Rails.logger.error("Error while importing CSV:#{filename}");
      Rails.logger.error(e.inspect);
      Rails.logger.error(e.backtrace);
    end
  end
end
