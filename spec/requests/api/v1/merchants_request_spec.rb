require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'get all merchants endpoint' do
    it 'returns a list of all merchants' do
      create_list(:merchant, 3)

      get api_v1_merchants_path

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(merchants).to be_a(Hash)

      expect(merchants[:data].count).to eq(3)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant[:attributes]).to be_a(Hash)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe 'get one merchant endpoint' do
    it 'can get one merchant by its id' do

      merchant1 = create(:merchant)

      get api_v1_merchant_path(merchant1.id)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant).to be_a(Hash)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end
end
