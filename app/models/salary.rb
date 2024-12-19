class Salary < ApplicationRecord
  belongs_to :account
  has_many :salary_slab_inputs, dependent: :destroy
  accepts_nested_attributes_for :salary_slab_inputs, allow_destroy: true

  TIME_PERIODS = {
    1 => 'This month',
    2 => 'Last month',
    3 => 'This year',
    4 => 'Current Financial Year',
    5 => 'Previous Financial Year',
    6 => 'Custom'
  }.freeze

  validates :salary_id, presence: true, uniqueness: true
  validates :carer_id, presence: true
  validates :account_id, presence: true
  validates :time_period, presence: true
  validate :validate_custom_dates, if: -> { time_period == 'Custom' }

  before_save :set_time_period_value

  private

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

  def fiscal_start(date)
    date.month >= 4 ? Date.new(date.year, 4, 1) : Date.new(date.year - 1, 4, 1)
  end

  def validate_custom_dates
    if from_date.blank? || to_date.blank?
      errors.add(:base, 'From date and To date must be provided for a custom time period')
    elsif from_date > to_date
      errors.add(:base, 'From date cannot be later than To date')
    end
  end
end