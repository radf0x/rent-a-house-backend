# frozen_string_literal: true

class Api::UsersController < ApiController
  include DoorkeeperRegisterable
  skip_before_action :doorkeeper_authorize!, only: %i[create]

  def create
    return head :unauthorized unless oauth_app

    user = User.new(user_params)

    return render json: { error: user.errors }, status: :unprocessable_entity unless user.save
    
    render json: render_new_user(user), status: :ok
  end

  def show
    render json: current_user
  end

  private

  def user_params
    params.permit(:name, :email, :password, :role)
  end

  def render_new_user(user)
    access_token = create_access_token(user, oauth_app)
    {
      id: user.id,
      role: user.role,
      token_type: 'Bearer',
      access_token: access_token.token,
      refresh_token: refresh_token,
      expires_in: access_token.expires_in,
      created_at: access_token.created_at.to_time.to_i
    }
  end

  def oauth_app
    @oauth_app ||= Doorkeeper::Application.find_by(uid: params[:client_id])
  end
end
