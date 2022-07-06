# frozen_string_literal: true

FactoryBot.define do
  factory :property do
    image { FFaker::Internet.http_url }
    title { FFaker::Name.name }
    price { BigDecimal(rand(30000...100000)) }
    road { '' }
    rooms { rand(1..10) }
    trait :taipei_city do
      city { '台北市' }
      district { %w[中正區 中山區 北投區 萬華區 大同區 內湖區 松山區 大安區 信義區 士林區 南港區 文山區].sample }
      mrt_line { %w[台北車站 市政府 內湖].sample }
    end

    trait :new_taipei_city do
      city { '新北市' }
      district { %w[三重區 新店區 樹林區 淡水區 永和區 新莊區 中和區 土城區 板橋區 汐止區].sample }
      mrt_line { %w[北投 板橋 南港展覽館].sample }
    end
  end
end