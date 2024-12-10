class InvoiceItem < ApplicationRecord
  belongs_to :invoice

  validates :date, :quantity, :description, :unitPrice, :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
