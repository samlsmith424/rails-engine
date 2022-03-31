class Item < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true, format: { with: /[a-zA-Z]/}
  validates :description, presence: true
  validates :unit_price, numericality: true

  def self.find_all_items(search)
    # where('name ILIKE ?', "%#{search}%")
    where('name ILIKE ?', "%#{search}%").order(:name)
  end
end
