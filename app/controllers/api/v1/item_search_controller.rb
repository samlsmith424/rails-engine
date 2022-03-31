class Api::V1::ItemSearchController < ApplicationController
  def index
    if params[:name] == ""
      render json: { data: {message: 'No search matches, please try again'} }, status: 400
    elsif params[:name]
      items = Item.find_all_items(params[:name])
      if items == nil
        render json: { data: {message: 'No search matches, please try again'} }, status: 400
      else
        render json: ItemSerializer.new(items)
      end
    elsif params[:name] == nil
      render json: { data: {message: 'No search matches, please try again'} }, status: 400
    else
      render json: ItemSerializer.new(Item.find_all_items(params[:name]))
    end
  end
end
