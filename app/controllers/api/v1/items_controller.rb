class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    begin
      item = merchant.items.create!(item_params)
      render json: ItemSerializer.new(item), status: :created
    rescue ActiveRecord::RecordInvalid
      render json: { status: 'ERROR', message: 'Unable to create item'}, status: :bad_request
    end
  end

  def update
  item = Item.update(params[:id], item_params)
    if item.save
      render json: ItemSerializer.new(item)
    else
      render json: { status: 'ERROR', message: 'Unable to update item'}, status: :bad_request
    end
  end

  def destroy
    @item = Item.find(params[:id])
    empties = @item.find_empty_invoices
    @item.destroy!
    Invoice.find_by(id: empties).destroy!
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
