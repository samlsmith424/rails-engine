class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  has_many :invoice_items, through: :invoices

  def self.search(search)
    where("name ILIKE ?", "%#{search.strip}%").order(:name).first
  end

  def self.top_merchants_by_revenue(number)
    Merchant
    .joins(invoices: { invoice_items: :transactions } )
    .where(transactions: {result: "success"}, invoices: {status: "shipped"})
    .group('merchants.id')
    .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) as total_revenue")
    .order('total_revenue DESC')
    .limit(number)
  end

  def self.merchants_by_item_quantity(number)
    Merchant
    .joins(invoices: { invoice_items: :transactions } )
    .where(transactions: {result: "success"}, invoices: {status: "shipped"})
    .group('merchants.id')
    .select("merchants.*, SUM(invoice_items.quantity) AS quantity_sold")
    .order("quantity_sold DESC")
    .limit(number)
  end

  def self.total_revenue_between_dates(start_date, end_date)
    start_date = start_date.to_datetime.beginning_of_day
    end_date = end_date.to_datetime.beginning_of_day
    Merchant
    .joins(invoices: { invoice_items: :transactions } )
    .where(transactions: {result: "success"}, invoices: {status: "shipped"})
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def self.total_revenue_by_merchant(merchant_id)
    Merchant
    .joins(invoices: { invoice_items: :transactions } )
    .where(transactions: {result: "success"}, invoices: {status: "shipped"})
    .group("merchants.id = ?", merchant_id)
    .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) as merchant_revenue")
  end
end
