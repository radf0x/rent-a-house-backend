# frozen_string_literal: true

class Api::RentalsController < ApiController
  before_action :admin_only, only: %i[create update delete]

  def index
    collections = Property.by_city(query_params[:city] || '')
      .by_districts(query_params[:districts] || [])
      .by_rooms(query_params[:rooms].to_i.abs)
      .by_rent(query_params[:min_rent].to_i.abs, query_params[:max_rent].to_i.abs)
      .by_mrt_line(query_params[:mrt_line] || '')
      .page(query_params[:page].to_i.abs || 1)

    render json: { properties: collections, pagination: pagination_data_from(collections) }, status: 200
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

  private

  def query_params
    @query_params ||= params.permit(:city, :rooms, :mrt_line, :min_rent, :max_rent, :page, districts: [])
  end

  def pagination_data_from(collection)
    next_page = collection.next_page ? collection.next_page : collection.current_page
    total_page = collection.total_pages.to_i ? collection.total_pages : collection.current_page
    {
      current: collection.current_page,
      next: next_page,
      total: total_page
    }
  end
end
