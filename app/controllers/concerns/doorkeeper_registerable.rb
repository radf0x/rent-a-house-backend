# frozen_string_literal: true

module DoorkeeperRegisterable
  extend ActiveSupport::Concern

  # generate a random token string and return it
  # unless there is already another token with the same string
  def generate_refresh_token
    loop do
      token = SecureRandom.hex(32)
      break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
    end
  end

  # create access token for the user, so the user won't need to login again after registration
  def render_user(user, client_app, token_type = 'Bearer')
    access_token = Doorkeeper::AccessToken.create(resource_owner_id: user.id,
                                                  application_id: client_app.id,
                                                  refresh_token: generate_refresh_token,
                                                  expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
                                                  scopes: '')

    {
      id: user.id,
      role: user.role,
      access_token: access_token.token,
      token_type: token_type,
      expires_in: access_token.expires_in,
      refresh_token: access_token.refresh_token,
      created_at: access_token.created_at.to_time.to_i
    }
  end
end
