class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if params[:quantity] == nil
      render json: { error: "bad request" }, status: :bad_request
    else
      number = params[:quantity]
      merchants = Merchant.top_merchants_by_revenue(number)
      render json: MerchantNameRevenueSerializer.new(merchants)
    end
  end

  def show
    merchant_id = params[:id]
    merchant = Merchant.total_revenue_by_merchant(merchant_id)
    render json: MerchantRevenueSerializer.new(merchant)
  end
end
