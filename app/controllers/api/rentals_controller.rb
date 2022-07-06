# frozen_string_literal: true

# TODO: add ActiveModel Serializer for json results
# TODO: add request param validators
class Api::RentalsController < ApiController
  before_action :admin_only, only: %i[create update delete]
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_error

  def index
    collections = Property.by_city(filter_params[:city] || '')
      .by_districts(filter_params[:districts] || [])
      .by_rooms(filter_params[:rooms].to_i.abs)
      .by_rent(filter_params[:min_rent].to_i.abs, filter_params[:max_rent].to_i.abs)
      .by_mrt_line(filter_params[:mrt_line] || '')
      .page(filter_params[:page].to_i.abs || 1)

    render json: { properties: collections, pagination: pagination_data_from(collections) }, status: 200
  end

  def show
    property = Property.find_by!(id: params[:id])
    render json: property, status: 200
  end

  def create
    # TODO
  end

  def update
    # TODO
  end

  def delete
    # TODO
  end

  private

  def filter_params
    @filter_params ||= params.permit(:city, :rooms, :mrt_line, :min_rent, :max_rent, :page, districts: [])
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

  def render_record_not_found_error(error)
    render json: { error: "Cound't find rental" }, status: :not_found
  end
end
