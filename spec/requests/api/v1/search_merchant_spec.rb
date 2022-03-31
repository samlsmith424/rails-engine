require 'rails_helper'

RSpec.describe 'search function' do
  it 'can find a merchant based on search criteria' do
    brad = create(:merchant, name: "Brad")
    brad_chad = create(:merchant, name: "Brad Chad")
    joe = create(:merchant, name: "Joe")

    get '/api/v1/merchants/find?name=Brad'

    results = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(results).to be_a(Hash)
    expect(results[:data]).to be_a(Hash)

    expect(results[:data]).to have_key(:type)
    expect(results[:data][:type]).to eq("merchant")

    expect(results[:data]).to have_key(:attributes)
    expect(results[:data][:attributes]).to be_a(Hash)

    expect(results[:data][:attributes][:name]).to eq("Brad")
    expect(results[:data][:attributes][:name]).to_not eq("Brad Chad")
    expect(results[:data][:attributes][:name]).to_not eq("Joe")
  end
end
