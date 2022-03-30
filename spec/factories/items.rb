FactoryBot.define do
  factory :item do
    name { Faker::Appliance.equipment }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Number.decimal(r_digits: 2) }
    merchant
  end
end
