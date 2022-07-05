# frozen_string_literal: true

namespace :rental do
  namespace :setup_db do
    desc 'Populate the database with rental listings from web'
    task from_web: :environment do
      @bot ||= Bots::RentalDataCrawler.new
      @bot.call
      @bot.insert_to_db
      true
    end

    desc 'Populate the database with rental listings from local file'
    task from_local: :environment do
      Bots::RentalDataCrawler.new.insert_to_db
      true
    end
  end

  namespace :truncate_rental_table do
    task property: :environment do
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        conn.execute("TRUNCATE #{Property.table_name} RESTART IDENTITY")
      end
      puts "Property table resetted"
      true
    end
  end
end
