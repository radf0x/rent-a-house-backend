# frozen_string_literal: true

RSpec.configure do |config|
  config.include Module.new {

    def basic_headers
      {
        'User-Agent': "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Chrome/103.0.5060.53",
        'Content-Type': 'application/json'
      }
    end

    def with_user_auth_headers(auth_token)
      basic_headers.merge('Authorization': "Bearer #{auth_token}")
    end
  }
end