class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice

  def self.total_revenue_between_dates(start_date, end_date)
    InvoiceItem.joins(:transactions).where(transactions: {result: "success"}, invoices: {status: "shipped"}).sum(
    "quantity * unit_price")
  end
end
