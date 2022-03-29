require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'get all merchants endpoint' do
    it 'returns a list of all merchants' do
      create_list(:merchant, 3)

      # get '/api/v1/merchants'
      get api_v1_merchants_path

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(merchants[:data].count).to eq(3)

      merchants[:data].each do |merchant|
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe 'get one merchant endpoint' do
    it 'can get one merchant by its id' do
      # id = create(:merchant).id
      merchant1 = create(:merchant)

      # get "/api/v1/merchants/#{id}"
      get api_v1_merchant_path(merchant1.id)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end
end
