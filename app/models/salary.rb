class Salary < ApplicationRecord
  # Associations
  belongs_to :account
  has_many :salary_slab_inputs, dependent: :destroy
  accepts_nested_attributes_for :salary_slab_inputs, allow_destroy: true

  # Constants for Time Period Options
  TIME_PERIODS = {
    1 => 'This month',
    2 => 'Last month',
    3 => 'This year',
    4 => 'Current Financial Year',
    5 => 'Previous Financial Year',
    6 => 'Custom'
  }.freeze

  # Validations
  validates :salary_id, presence: true, uniqueness: true
  validates :agent_id, presence: true
  validates :account_id, presence: true
  validates :time_period_id, presence: true, inclusion: { in: TIME_PERIODS.keys }
  validate :validate_custom_dates, if: -> { time_period_id == 6 }

  # Hooks
  before_save :set_time_period_value

  private

  # Set time period value based on selected time period
  def set_time_period_value
    self.time_period_value = case time_period_id
                             when 1
                               "#{Date.today.beginning_of_month} to #{Date.today}"
                             when 2
                               "#{Date.today.last_month.beginning_of_month} to #{Date.today.last_month.end_of_month}"
                             when 3
                               "#{Date.today.beginning_of_year} to #{Date.today}"
                             when 4
                               fiscal_start_date = fiscal_start(Date.today)
                               "#{fiscal_start_date} to #{Date.today}"
                             when 5
                               fiscal_start_date = fiscal_start(Date.today.prev_year)
                               fiscal_end_date = fiscal_start_date + 1.year - 1.day
                               "#{fiscal_start_date} to #{fiscal_end_date}"
                             when 6
                               from_date.present? && to_date.present? ? "#{from_date} to #{to_date}" : 'Custom'
                             else
                               'Invalid'
                             end
  end

  # Calculate the fiscal start date
  def fiscal_start(date)
    date.month >= 4 ? Date.new(date.year, 4, 1) : Date.new(date.year - 1, 4, 1)
  end

  # Custom validation for custom time periods
  def validate_custom_dates
    if from_date.blank? || to_date.blank?
      errors.add(:base, 'From date and To date must be provided for a custom time period')
    elsif from_date > to_date
      errors.add(:base, 'From date cannot be later than To date')
    end
  end
end
