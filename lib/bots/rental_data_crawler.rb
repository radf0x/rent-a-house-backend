# frozen_string_literal: true

class Bots::RentalDataCrawler

  def config
    @config ||= Rails.application.config_for(:rental_data_crawler)
  end

  def base_url
    @base_url ||= config[:base_url]
  end

  def queries
    @queries ||= config[:filter]
  end

  def filter
    url_encoded = ERB::Util.url_encode(queries.to_json)
    Base64.urlsafe_encode64(url_encoded, padding:false)
  end

  def sort
    @sort ||= config[:sort]
  end

  def csv_headings
    @headings ||= %w(image title price city district road rooms mrt_line)
  end

  def call(page=1)
    entries = []
    # get first page
    sort[:page] = page.to_i if page.to_i > 1
    data = listings(sort)
    entries << data.dig('data','items')

    pagination_data = data.dig('data','pagination').to_a
    # if pages = [] meaning no need pagination
    return true if pagination_data.empty?

    # crawl and store the rest of the pages
    pagination_data # [ ["1", "lower"], ..., ["7", "last"] ]
      .collect(&:first)
      .last
      .to_i 
      .times do |i|
        sort[:page] = i+1
        data = listings(sort)
        entries << data.dig('data','items')
      end

    to_csv(entries)
  end

  def insert_to_db
    local_file_path = Rails.root.join('lib','bots',"rental_data.csv")
    raise LoadError.new("rentals_data.csv not found") unless File.exists?(local_file_path)

    puts "Inserting database records from #{local_file_path}"
    CSV.foreach(local_file_path, headers: true) do |row|
      Property.create!(row.to_hash)
    end
    puts "#{Property.count} records added"
  end

  private

  def to_csv(collection)
    CSV.open(Rails.root.join('lib','bots',"rental_data.csv"), "wb") do |csv|
      csv << csv_headings

      collection.each do |items|
        items.sample(config[:num_of_result]).each do |item|
          csv << [
            item['image_url'],
            item['title'],
            item['rent'],
            item['city'],
            item['dist'],
            item['road'],
            item['total_room'],
            item['closest_mrt']
          ]
        end
      end
    end
  end

  def listings(sort)
    req_url = "#{base_url}?filter=#{filter}&#{sort.to_query}"
    puts "Fetching from #{req_url}"
    resp = HTTParty.get(req_url)
    # non 200
    raise StandardError.new("failed to fetch with url: #{url}") unless resp.ok?

    resp.parsed_response
  end
end