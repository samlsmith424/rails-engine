class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    if params[:quantity] == ""
      render json: {}, status: :bad_request
    elsif !params.keys.include?("quantity")
      render json: { error: "bad request"}, status: :bad_request
    else
      number = params[:quantity]
      merchants = Merchant.merchants_by_item_quantity(number)
      render json: ItemsSoldSerializer.new(merchants)
    end
  end
end
