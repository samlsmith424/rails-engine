class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, presence: true, format: { with: /[a-zA-Z]/}
  validates :description, presence: true
  validates :unit_price, numericality: true

  def self.find_all_items(search)
    # where('name ILIKE ?', "%#{search}%")
    where('name ILIKE ?', "%#{search}%").order(:name)
  end

  def find_empty_invoices
    # invoices.joins(:items).select('invoices.*, count(items.*)').group('invoices.id').having('count(items.*) = 1')
    invoices.joins(:items).select('invoices.*, count(items.*)').group('invoices.id').having('count(items.*) = 1').pluck(:id)
  end
end
