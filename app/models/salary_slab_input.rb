class SalarySlabInput < ApplicationRecord
  # Associations
  belongs_to :salary

  # Validations
  validates :id, presence: true
  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
