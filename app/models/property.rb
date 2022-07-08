# frozen_string_literal: true

class Property < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes

  scope :by_city, ->(city) { where(city: city) unless city.blank? }
  scope :by_districts, ->(districts) { where(district: districts) unless districts.empty? }
  scope :by_rooms, ->(rooms) { where('rooms <= ?', rooms) unless rooms == 0 }
  scope :by_mrt_line, ->(mrt_line) { where(mrt_line: mrt_line) unless mrt_line.blank? }
  scope :by_rent, lambda { |min, max|
    return if min.zero? && max.zero?
    return between_rent_price(min, max) if !min.zero? && !max.zero? 
    return max_rent_price(max) if min.zero?
    return min_rent_price(min) if max.zero?
  }
  scope :by_floor_size, lambda { |min, max|
    return if min.zero? && max.zero?
    return between_floor_size(min, max) if !min.zero? && !max.zero? 
    return max_floor_size(max) if min.zero?
    return min_floor_size(min) if max.zero?
  }
  scope :sort_price_asc, -> { order(price: :asc) }
  scope :between_rent_price, ->(min, max) { where('price between ? and ?', min, max) unless (min + max).zero? }
  scope :min_rent_price, ->(price) { where('price >= ?', price) }
  scope :max_rent_price, ->(price) { where('price <= ?', price) }
  scope :between_floor_size, ->(min, max) { where('floor_size between ? and ?', min, max) }
  scope :min_floor_size, ->(size) { where('floor_size >= ?', size) }
  scope :max_floor_size, ->(size) { where('floor_size <= ?', size) }
end
