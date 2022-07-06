# frozen_string_literal: true

FactoryBot.define do
  factory :doorkeeper_application, class: Doorkeeper::Application do
    name { 'Rentals' }
    redirect_uri { '' }
    scopes { '' }
  end

  factory :doorkeeper_access_token, class: Doorkeeper::AccessToken do
    association :application, factory: :doorkeeper_application
    resource_owner_id { create(:user).id }
  end
end
