# frozen_string_literal: true

class Api::RentalsController < ApiController
  before_action :admin_only, only: %i[create update delete]

  def index
    # TODO: list rentals
    # pagination, 6 per page
    # filter by district | city | price (min, max) | room number
    render json: { rentals: [1,2,3,4] }, status: 200
  end

  def show
    puts "SHOW"
  end

  def create
    puts "hihi"
    render json: { user: current_user }, status: 200
  end

  def update
  end

  def delete
  end
end
