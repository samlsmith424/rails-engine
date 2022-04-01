require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_numericality_of :unit_price }
    it { should validate_presence_of :description }
  end

  describe 'class methods' do
    it 'returns all items based on search criteria' do
      fork = create(:item, name: "Fork")
      fork2 = create(:item, name: "Fork and Knife")
      spoon = create(:item, name: "Spoon")

      expect(Item.find_all_items("fork")).to eq([fork, fork2])
      expect(Item.find_all_items("fork")).to_not eq([spoon])
    end
  end
end
