class Merchant < ApplicationRecord
  has_many :items

  def self.search(search)
    find_by("name ILIKE ?", "%#{search.strip}%")
  end
end
