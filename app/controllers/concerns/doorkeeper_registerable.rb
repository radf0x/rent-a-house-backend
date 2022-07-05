# frozen_string_literal: true

module DoorkeeperRegisterable
  extend ActiveSupport::Concern

  # generate a random token string and return it
  # unless there is already another token with the same string
  def refresh_token
    loop do
      token = SecureRandom.hex(32)
      break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
    end
  end

  # create access token for the user, so the user won't need to login again after registration
  def create_access_token(user, app)
    Doorkeeper::AccessToken.create(resource_owner_id: user.id,
                                                  application_id: app.id,
                                                  refresh_token: refresh_token,
                                                  expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
                                                  scopes: '')
  end
end
