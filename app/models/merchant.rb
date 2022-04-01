class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.search(search)
    # select("name ILIKE ?", "%#{search.strip}%").order(:name).limit(1)

    where("name ILIKE ?", "%#{search.strip}%").order(:name).first
    # find_by("name ILIKE ?", "%#{search.strip}%")
  end
end
