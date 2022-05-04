require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
  end

  describe 'class methods' do
    it 'return the first object in the database in case-sensitive alphabetical order if multiple matches are found' do
      chad = create(:merchant, name: "Chad")
      brad = create(:merchant, name: "Brad")

      expect(Merchant.search("ad")).to eq(brad)
      expect(Merchant.search("ad")).to_not eq(chad)
    end
  end
end
