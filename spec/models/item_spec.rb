require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should belong_to :merchant }
  it { should validate_presence_of :name }
  it { should validate_numericality_of :unit_price }
  it { should validate_presence_of :description }

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
