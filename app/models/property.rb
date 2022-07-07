# frozen_string_literal: true

class Property < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes

  scope :by_city, ->(city) { where(city: city) unless city.blank? }
  scope :by_districts, ->(districts) { where(district: districts) unless districts.empty? }
  scope :by_rooms, ->(rooms) { where('rooms <= ?', rooms) unless rooms == 0 }
  scope :by_rent, ->(min, max) { where('price between ? and ?', min.to_i, max.to_i) unless (min + max).zero? }
  scope :by_mrt_line, ->(mrt_line) { where(mrt_line: mrt_line) unless mrt_line.blank? }
  scope :sort_price_asc, -> { order(price: :asc) }
end
