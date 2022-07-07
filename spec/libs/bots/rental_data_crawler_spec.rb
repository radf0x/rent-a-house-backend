# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Bots::RentalDataCrawler do
  context 'fetch rental records from the web' do
    it 'write to CSV' do
      VCR.use_cassette("lib/bots/rentals") do
        # stub the to_csv method to prevent overwriting the .csv
        expect(subject).to receive(:to_csv).and_return(true)
        subject.call
      end
    end
  end

  context 'insert records to db' do
    context 'when csv file is present' do
      before do
        subject.instance_variable_set(:@csv_file_path, Rails.root.join('spec', 'fixtures', 'rental_data.csv'))
      end
  
      it 'inserted 3 records to Property' do
        expect(Property.count).to eq(0)
        subject.insert_to_db
        expect(Property.count).to eq(3)
      end
    end

    context 'when csv file is missing' do
      before do
        subject.instance_variable_set(:@csv_file_path, 'bogus')
      end

      it 'raises LoadError if file not found' do
        expect{ subject.insert_to_db }.to raise_error(LoadError)
      end
    end
  end
end