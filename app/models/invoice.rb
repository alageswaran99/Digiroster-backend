class Invoice < ApplicationRecord
    # Associations
    belongs_to :account
    belongs_to :client
    belongs_to :group
    belongs_to :region
    has_many :invoice_items, dependent: :destroy
  
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
    validates :invoiceId, presence: true
    validates :clientId, presence: true
    validates :timePeriod, presence: true, inclusion: { in: TIME_PERIODS.keys }
    validates :ratePerMinute, numericality: { greater_than_or_equal_to: 0 }
    validate :validate_custom_dates, if: -> { timePeriod == 6 }
  
    # Hooks
    before_save :set_invoice_date, if: -> { invoiceDate.blank? }
    before_save :set_time_period_value
  
    # Method to calculate the total amount of the invoice based on items
    def calculate_total_amount
      self.totalAmount = invoice_items.sum(:amount)
    end
  
    private
  
    # Set the invoice date if not provided
    def set_invoice_date
      self.invoiceDate = Date.today
    end
  
    # Set the time period value based on the selected time period
    def set_time_period_value
      self.timePeriodValue = case timePeriod
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
                               fromDate.present? && toDate.present? ? "#{fromDate} to #{toDate}" : 'Custom'
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
      if fromDate.blank? || toDate.blank?
        errors.add(:base, 'From date and To date must be provided for a custom time period')
      elsif fromDate > toDate
        errors.add(:base, 'From date cannot be later than To date')
      end
    end
  end
  