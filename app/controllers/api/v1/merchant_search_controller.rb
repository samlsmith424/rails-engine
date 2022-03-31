class Api::V1::MerchantSearchController < ApplicationController
  def show
    if params[:name] == ""
      render json: { data: {message: 'No search matches, please try again'} }, status: 400
      
    elsif params[:name]
      merchant = Merchant.search(params[:name])
      if merchant == nil
        render json: { data: {message: 'No search matches, please try again'} }, status: 400
      else
        render json: MerchantSerializer.new(merchant)
      end
    # elsif params[:name] == ""
    #   require "pry"; binding.pry
    #   render json: { data: {message: 'No search matches, please try again'} }, status: 400
    elsif params[:name] == nil
      render json: { data: {message: 'No search matches, please try again'} }, status: 400
    else
      render json: MerchantSerializer.new(Merchant.search(params[:name]))
    end
  end
end
