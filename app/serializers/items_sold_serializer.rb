class ItemsSoldSerializer
  include JSONAPI::Serializer
  attributes :name

  attributes :count do |object|
    object.quantity_sold
  end
end
