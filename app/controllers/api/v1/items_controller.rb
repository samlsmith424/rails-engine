class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.create(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def update
    item = Item.update(params[:id], item_params)
    if item.save
      render json: ItemSerializer.new(item)
    else
      render status: :bad_request
    end
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
