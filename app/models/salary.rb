class Salary < ApplicationRecord
  # Associations
  belongs_to :account
  has_many :salary_slab_inputs, dependent: :destroy

  # Validations
  validates :salary_id, presence: true, uniqueness: true
  validates :agent_id, presence: true
  validates :account_id, presence: true
  validates :group_id, presence: true
  validates :region_id, presence: true
  validates :time_period, presence: true, uniqueness: { scope: [:account_id, :agent_id], message: "already generated for this time period" }
  validates :customized_checkbox, inclusion: { in: [true, false] }

  # Nested attributes
  accepts_nested_attributes_for :salary_slab_inputs, allow_destroy: true
end
