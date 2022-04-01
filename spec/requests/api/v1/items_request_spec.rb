require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'get all items endpoint' do
    it 'returns a list of all items' do
      create_list(:item, 4)

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

      id = create(:item).id

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

    it 'does not create an item if all fields are not input properly' do

      merchant1 = create(:merchant)
      item_params = {
                  "name": "Strainer",
                  "description": "Strains water from food items",
                  "unit_price": "Not an integer",
                  "merchant_id": merchant1.id
                }

      headers = {"CONTENT_TYPE" => "application/json"}
      expect(merchant1.items.count).to eq(0)

      post "/api/v1/items", headers: headers, params: item_params.to_json

      idk = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(idk[:message]).to eq("Unable to create item")
    end
  end

  describe 'editing an item' do
    it 'can edit an item' do
      merchant_id = create(:merchant).id
      item1 = create(:item, merchant_id: merchant_id)

      original_data = Item.last.name

      item_params = {
                  "name": "Very very new item",
                }

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item1.id}", headers: headers, params: JSON.generate({item: item_params})
      updated_item = Item.find_by(id: item1.id)

      expect(response).to be_successful
      expect(updated_item.name).to_not eq(original_data)
      expect(updated_item.name).to eq("Very very new item")
    end

    it 'does not edit an item if input is invalid' do
      merchant_id = create(:merchant).id
      item1 = create(:item, merchant_id: merchant_id)
      original_data = Item.last.name

      item_params = {
                  "name": 10.99999,
                }

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item1.id}", headers: headers, params: JSON.generate({item: item_params})
      updated_item = Item.find_by(id: item1.id)
      idk = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(400)
      expect(idk[:message]).to eq("Unable to update item")
    end
  end

  describe 'deleting an item' do
    xit 'can delete an item' do
      item1 = create(:item)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item1.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
    end

    it 'deletes the invoice if only one item was present' do
      @nike = Merchant.create!(name: 'Nike')
      @item1 = create(:item)
      @item2 = create(:item)
      @item3 = create(:item)
      @customer_1 = Customer.create(first_name: 'One', last_name: 'Customer')
      @customer_2 = Customer.create(first_name: 'Two', last_name: 'Customer')
      @customer_3 = Customer.create(first_name: 'Three', last_name: 'Customer')
      @invoice_1 = Invoice.create(customer_id: @customer_1.id, merchant_id: @nike.id, status: '1')
      @invoice_2 = Invoice.create(customer_id: @customer_1.id, merchant_id: @nike.id, status: '1')
      @invoice_item_1 = InvoiceItem.create(quantity: 1, unit_price: 100.0, invoice_id: @invoice_1.id, item_id: @item1.id)
      @invoice_item_2 = InvoiceItem.create(quantity: 1, unit_price: 100.0, invoice_id: @invoice_1.id, item_id: @item2.id)
      @invoice_item_3 = InvoiceItem.create(quantity: 1, unit_price: 100.0, invoice_id: @invoice_1.id, item_id: @item3.id)
      @invoice_item_4 = InvoiceItem.create(quantity: 1, unit_price: 100.0, invoice_id: @invoice_2.id, item_id: @item3.id)

      expect(Item.count).to eq(3)
      expect(Customer.count).to eq(3)
      expect(Invoice.count).to eq(2)
      expect(InvoiceItem.count).to eq(4)
      expect(@invoice_1.invoice_items.count).to eq(3)
      expect(@invoice_2.invoice_items.count).to eq(1)

      delete api_v1_item_path(@item3.id)

      expect(response).to have_http_status(204)
      expect(Item.count).to eq(2)
      expect { Item.find(@item3.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(@invoice_1.invoice_items.count).to eq(2)
      expect(@invoice_2.invoice_items.count).to eq(0)
      expect(Invoice.count).to eq(1)
    end
  end
end
