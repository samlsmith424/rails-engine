require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'get all items endpoint' do
    it 'returns a list of all items' do
      create_list(:item, 4)

      # get '/api/v1/items'
      get api_v1_items_path

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(4)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
      end
    end
  end

  describe 'get one items endpoint' do
    it 'returns one item by id' do
      # item = create(:item)
      id = create(:item).id

      # get "/api/v1/items/#{id}"
      get api_v1_item_path(id)

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_a(String)

      expect(item[:data]).to have_key(:attributes)
      expect(item[:data][:attributes]).to be_a(Hash)

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    end
  end

  describe 'creating an item' do
    it 'can create an item' do
      merchant_id = create(:merchant).id
      item_params = {
                  "name": "Strainer",
                  "description": "Strains water from food items",
                  "unit_price": 12.15,
                  "merchant_id": merchant_id
                }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: item_params.to_json
      created_item = Item.last

      expect(response).to be_successful

      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
    end
  end
end
