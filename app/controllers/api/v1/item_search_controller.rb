class Api::V1::ItemSearchController < ApplicationController
  def index
    # if params name
    items = Item.find_all_items(params[:name])
    render json: ItemSerializer.new(items)
    # else 404
  end
end
