class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.search(search)
    where("name ILIKE ?", "%#{search.strip}%").order(:name).first
  end
end
