require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'relationships' do
    it { should have_many(:items) }
  end

  describe 'class methods' do
    it 'can find a merchant based on search criteria' do
      
    end
  end
end
