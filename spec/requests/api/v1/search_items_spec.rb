require 'rails_helper'

RSpec.describe 'items search' do
  it 'finds all items based on search criteria' do
    fork = create(:item, name: "Fork")
    fork2 = create(:item, name: "Fork and Knife")
    fortune = create(:item, name: "Fortune cookie")
    spoon = create(:item, name: "Spoon")

    get '/api/v1/items/find_all?name=for'

    results = JSON.parse(response.body, symbolize_names: true)
# require "pry"; binding.pry
    expect(response).to be_successful
    expect(results).to be_a(Hash)
    expect(results).to have_key(:data)
    expect(results[:data].count).to eq(3)

    results[:data].each do |result|
      expect(result).to have_key(:attributes)
      expect(result[:attributes]).to be_a(Hash)

      expect(result[:attributes]).to have_key(:name)
      expect(result[:attributes][:name]).to_not eq("Spoon")
    end
  end
end
