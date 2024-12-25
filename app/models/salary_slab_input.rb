class SalarySlabInput < ApplicationRecord
  belongs_to :salary

  validates :rate, presence: true, numericality: { greater_than: 0 }
end