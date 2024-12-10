class RecurringTask < ApplicationRecord
  store_accessor :other_info, :services, :scheduled_days, :agent_ids, :version_id
  attr_accessor :job_not_needed

  belongs_to_account
  belongs_to :client, optional: true
  belongs_to :created_by, class_name: "Agent", optional: true
  has_many :appointments

  before_create :set_default_data
  before_update :check_version
  after_commit :prepare_scheduler, on: :create
  after_commit :update_scheduler, on: :update
  validate :check_task_date
  validates :start_time, presence: true

  def api_format
    AppointmentDecorator.new(rt, {decorator_method: :recurring_api}).api_decorate
  end

  def formatted_start_time
    self.start_time.strftime('%H:%M')
  end

  def formatted_end_time
    self.end_time.strftime('%H:%M')
  end

  def agents
    Account.current.agents.where(id: self.agent_ids)
  end

  def formatted_task_end_date
    return nil if self.task_end_date && self.task_end_date.year > 2100
    
    self.task_end_date
  end

  def create_appt(for_date)
    appt = build_appt(for_date)
    appt.save
    appt
  end

  def check_task_date
    return true if self.task_end_date.nil? || self.task_end_date.future?
    
    errors.add(:task_end_date, "must be in future")
  end

  def build_appt(for_date)
    appt = self.appointments.new
    appt.client = self.client
    appt.notes = self.notes
    appt.recurring = true
    appt.services = self.services
    appt.start_time = DateTime.new(for_date.year, for_date.month, for_date.day, self.start_time.hour, self.start_time.min)
    appt.end_time = DateTime.new(for_date.year, for_date.month, for_date.day, self.end_time.hour, self.end_time.min)
    appt.created_by = self.created_by
    build_agent_appt(appt)
    appt
  end

  private

    def build_agent_appt(appt)
      self.agent_ids.each do |x|
        appt.agent_appointments.new({agent_id: x})
      end
    end

    def check_version
      return if (self.changes.keys - ['notes']).blank?

      self.version_id = SecureRandom.hex(20)
    end

    def set_default_data
      self.scheduled_days.sort!
      self.task_end_date ||= 100.years.from_now
      self.version_id = SecureRandom.hex(20)
      self.created_by ||= User.current
    end

    def prepare_scheduler
      RecurringAppointmentJob.perform_later({task_id: self.id, account_id: self.account.id, version_id: self.version_id})
    end

    def update_scheduler
      return if job_not_needed
      
      UpdateRecurringJob.perform_later({task_id: self.id, account_id: self.account.id, version_id: self.version_id})
    end
end
