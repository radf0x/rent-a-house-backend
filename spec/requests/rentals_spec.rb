require 'rails_helper'

RSpec.describe "Rentals", type: :request do
  describe 'when authorized as admin' do
    let!(:application) { FactoryBot.create(:doorkeeper_application) }
    let!(:user) { FactoryBot.create(:user, :with_admin) }
    let!(:auth_token) { FactoryBot.create(:doorkeeper_access_token, application: application, resource_owner_id: user.id).token }

    describe 'POST /api/rentals' do
      context 'created a rental property' do
        let(:params) do
          {
            image: FFaker::Internet.http_url,
            title: FFaker::Name.name,
            price: BigDecimal(30000),
            road: '',
            rooms: rand(1..10),
            city: '台北市',
            district: %w[中正區 中山區 北投區 萬華區 大同區 內湖區 松山區 大安區 信義區 士林區 南港區 文山區].sample,
            mrt_line: %w[台北車站 市政府 內湖].sample
          }
        end

        before do
          expect(Property.count).to eq 0
        end

        after do
          expect(response).to have_http_status(:created)
        end

        it 'created a property record' do
          post '/api/rentals', params: params.to_json, headers: with_user_auth_headers(auth_token)
          expect(Property.count).to eq 1
        end

        it 'respond with http 201 and property id' do
          post '/api/rentals', params: params.to_json, headers: with_user_auth_headers(auth_token)
          expect(response.parsed_body).to include_json(
            id: Property.first.id
          )
        end
      end
    end
  end

  describe 'when authorized as user' do
    let!(:application) { FactoryBot.create(:doorkeeper_application) }
    let!(:user) { FactoryBot.create(:user) }
    let!(:auth_token) { FactoryBot.create(:doorkeeper_access_token, application: application, resource_owner_id: user.id).token }
  
    before do
      10.times { FactoryBot.create(:property, :taipei_city) }
      10.times { FactoryBot.create(:property, :new_taipei_city) }
    end
  
    describe 'POST /api/rentals' do
      context 'user is not able to create new rental record' do
        it 'respond with 403' do
          post '/api/rentals', headers: with_user_auth_headers(auth_token)
          expect(response).to have_http_status(:forbidden)
        end

        it 'record is not created' do
          total = Property.count
          post '/api/rentals', headers: with_user_auth_headers(auth_token)
          expect(Property.count).to eq total
        end
      end
    end

    describe 'GET /api/rentals/:id' do
      let(:property) { FactoryBot.create(:property, :taipei_city) }
  
      it 'respond with the correct property' do
        get "/api/rentals/#{property.id}", headers: with_user_auth_headers(auth_token)
        expect(response.parsed_body['id']).to eq property.id
      end
  
      it 'respond with 404 with not found error message' do
        get "/api/rentals/#{-property.id}", headers: with_user_auth_headers(auth_token)
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['error']).to eq "Cound't find rental"
      end
    end
  
    describe "GET /api/rentals" do
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

  describe 'when not authorized' do
    shared_examples_for 'GET /api/rentals' do
      it 'respond with http 401' do
        get endpoint
        expect(response).to have_http_status(:unauthorized)
      end
    end
    
    it_behaves_like 'GET /api/rentals' do
      let(:endpoint) { '/api/rentals' }
    end

    it_behaves_like 'GET /api/rentals' do
      let(:endpoint) { '/api/rentals/1' }
    end
  end
end
