require 'rails_helper'

RSpec.describe 'Merchant Items API' do
  xit 'gets all items for a given merchant id' do
    merchant1 = create(:merchant)
    items = create_list(:item, 3, merchant_id: merchant1.id)

    # get "/merchants/#{merchant1.id}/items"
    get api_v1_merchant_items_path(merchant1.id)

    merchant_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    # need to test merchant items count to be 3
    # have item attributes and merchant1 id
  end
end
