class Appointment < ApplicationRecord
  store_accessor :other_info, :services, :cancelled_details
  enum appt_status: { active: 1, cancelled: 3}

  belongs_to_account
  belongs_to :recurring_task, class_name: "RecurringTask", foreign_key: "recurring_task_id", optional: true
  has_many :feedbacks
  belongs_to :client
  belongs_to :created_by, class_name: "Agent", optional: true
  has_many :agent_appointments, dependent: :destroy
  has_many :agents, through: :agent_appointments
  has_many :emergency_notes, class_name: "Note"

  accepts_nested_attributes_for :agent_appointments #, reject_if: proc { |attributes| (attributes.blank? || attributes[:agent_id].blank?) }
  accepts_nested_attributes_for :feedbacks

  validate :services_list
  validates_uniqueness_of :client_id, scope: [:account_id, :recurring_task_id, :start_time, :end_time]

  before_create :set_default_data
  # before_update :check_can_edit
  # before_destroy :check_can_edit, prepend: true
  
  filter_by :client_id
  filter_by :agent_id, joins: :agent_appointments

  default_scope -> { order(created_at: :desc) }
  scope :upcoming, -> { where("end_time >= ?",Time.now)}
  scope :unclosed, -> { where("agent_appointments.status != ?",AgentAppointment.statuses[:completed])}

  def services_list
    unless (self.services.to_a - self.client.services).empty?
      errors.add(:services, "Invalid services")
    end
  end

  def set_default_data
    self.recurring ||= false
    self.created_by ||= User.current
  end

  def check_can_edit
    return true if self.allow_edit?
    
    errors.add("Appointment InProgress ", "Some of the Agent attended")
    false
    # throw :abort
  end

  def cancel_note
    if self.cancelled_details
      self.cancelled_details['note']
    end
  end

  def cancel(cancel_note)
    self.appt_status = 3
    self.cancelled_details = {
      user_id: User.current.id,
      note: cancel_note
    }
    if self.save
      self.agent_appointments.each do |ag_appt|
        ag_appt.status = AgentAppointment.statuses[:cancelled]
        ag_appt.save
      end
    end
    self.cancelled?
  end

  def allow_edit?
    self.agent_appointments.agent_touched.none?
  end

end
