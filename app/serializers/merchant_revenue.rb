class MerchantRevenueSerializer
  include JSONAPI::Serializer
  attributes :name

  attributes :revenue do |object|
    object.merchant_revenue
  end
end
