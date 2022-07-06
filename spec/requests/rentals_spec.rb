require 'rails_helper'

RSpec.describe "Rentals", type: :request do
  describe "GET /api/rentals" do
    before do
      10.times { FactoryBot.create(:property, :taipei_city) }
      10.times { FactoryBot.create(:property, :new_taipei_city) }
    end

    context 'when authorized' do
      let!(:application) { FactoryBot.create(:doorkeeper_application) }
      let!(:user) { FactoryBot.create(:user) }
      let!(:auth_token) { FactoryBot.create(:doorkeeper_access_token, application: application, resource_owner_id: user.id).token }

      after do
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['pagination']).to include_json(
          current: /\d/,
          next: /\d/,
          total: /\d/
        )
      end

      context 'with a single filter' do
        it 'respond with properties that have rooms within the filter value' do
          num_of_rooms = rand(1..5)
          get '/api/rentals', params: { rooms: num_of_rooms }, headers: with_user_auth_headers(auth_token)
          response.parsed_body['properties'].each do |property|
            expect(property['rooms']).to be <= num_of_rooms
          end
        end

        it 'respond with properties that are in Taipei City' do
          get '/api/rentals', params: { city: '台北市' }, headers: with_user_auth_headers(auth_token)
          response.parsed_body['properties'].each do |property|
            expect(property['city']).to eq '台北市'
          end
        end
      end

      context 'with a composite filter' do
        let!(:districts) { %w[中正區 中山區] }
        let!(:query_params) { { city: '台北市', districts: districts, mrt_line: '台北車站' , max_rent: 30000} }

        before do
          districts.each do |district|
            FactoryBot.create(:property, :taipei_city, price: 30000.to_d, district: district, mrt_line: query_params[:mrt_line])
          end
        end

        it 'respond with properties that matches the filter' do
          get '/api/rentals', params: query_params, headers: with_user_auth_headers(auth_token)
          response.parsed_body['properties'].each do |property|
            expect(property['city']).to eq query_params[:city]
            expect(property['mrt_line']).to eq query_params[:mrt_line]
            expect(property['price'].to_d).to be <= query_params[:max_rent]
            expect(query_params[:districts]).to include property['district']
          end
        end
      end
    end
  end
end
