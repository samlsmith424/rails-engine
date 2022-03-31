class Api::V1::MerchantSearchController < ApplicationController
  def show
    if params[:name]
      merchant = Merchant.search(params[:name])
      if merchant == nil
        render json: { data: {message: 'No search matches, please try again'} }, status: 400
      else
        render json: MerchantSerializer.new(merchant)
      end
    elsif params[:name] == ""
      render json: { data: {message: 'No search matches, please try again'} }, status: 400
    elsif params[:name] == nil
      render json: { data: {message: 'No search matches, please try again'} }, status: 400
    else
      render json: MerchantSerializer.new(Merchant.search(params[:name]))
    end
  end
end
# if params[:name] == nil
#   render json: { data: {message: 'No search matches, please try again'} }, status: :ok
# else
#   render json: MerchantSerializer.new(Merchant.search(params[:name]))
# end



#   if params[:name]
#     merchant = Merchant.search(params[:name])
#     if merchant == nil
#       render json: { data: {message: 'No search matches, please try again'} }, status: :ok
#     else
#       render json: MerchantSerializer.new(merchant)
#     end
#   elsif params[:name] == ""
#     render json: { data: {message: 'No search matches, please try again'} }, status: :ok
#   elsif params[:name].nil?
#     render json: { data: {message: 'No search matches, please try again'} }, status: 400
#   else
#     render json: MerchantSerializer.new(Merchant.search(params[:name]))
#   end
# end
