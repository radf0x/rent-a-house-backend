# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    role { User.roles[:user] }
    password { FFaker::Internet.password }
  end
end