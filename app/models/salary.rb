class Salary < ApplicationRecord
  has_many :salary_slab_inputs, dependent: :destroy
  accepts_nested_attributes_for :salary_slab_inputs, allow_destroy: true

  # Constants for time periods
  TIME_PERIODS = {
    1 => 'This month',
    2 => 'Last month',
    3 => 'This year',
    4 => 'Current Financial Year',
    5 => 'Previous Financial Year',
    6 => 'Custom'
  }.freeze

  # Validations
  # validates :salary_id, presence: true, uniqueness: true
  # validates :carer_id, presence: true
  # validates :account_id, presence: true
  # validates :time_period, presence: true, inclusion: { in: TIME_PERIODS.values, message: "%{value} is not a valid time period" }
 
  belongs_to :client, optional: true
  belongs_to :group, optional: true
  belongs_to :region, optional: true
  validates :timePeriod, presence: true
 
  validates :rate_per_minute, presence: true, numericality: { greater_than_or_equal_to: 0, message: "must be a positive value" }
  validates :invoice_date, presence: true
  validate :validate_custom_dates, if: -> { time_period == 'Custom' }

  # Callbacks
  before_save :set_time_period_value

  # Define custom date attributes if using a custom time period
  attr_accessor :from_date, :to_date

  private

  # Set time period value based on the time period selected
  def set_time_period_value
    self.time_period_value = case time_period
                             when 'This month'
                               "#{Date.today.beginning_of_month} to #{Date.today}"
                             when 'Last month'
                               "#{Date.today.last_month.beginning_of_month} to #{Date.today.last_month.end_of_month}"
                             when 'This year'
                               "#{Date.today.beginning_of_year} to #{Date.today}"
                             when 'Current Financial Year'
                               fiscal_start = fiscal_start(Date.today)
                               "#{fiscal_start} to #{Date.today}"
                             when 'Previous Financial Year'
                               fiscal_start = fiscal_start(Date.today.prev_year)
                               fiscal_end = fiscal_start + 1.year - 1.day
                               "#{fiscal_start} to #{fiscal_end}"
                             when 'Custom'
                               from_date && to_date ? "#{from_date} to #{to_date}" : 'Custom'
                             else
                               'Invalid'
                             end
  end

  # Determine the fiscal start date based on the month (April starts the fiscal year)
  def fiscal_start(date)
    date.month >= 4 ? Date.new(date.year, 4, 1) : Date.new(date.year - 1, 4, 1)
  end

  # Validate custom dates (when time period is custom)
  def validate_custom_dates
    if from_date.blank? || to_date.blank?
      errors.add(:base, 'From date and To date must be provided for a custom time period')
    elsif from_date > to_date
      errors.add(:base, 'From date cannot be later than To date')
    end
  end
end
