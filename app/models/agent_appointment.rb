class AgentAppointment < ApplicationRecord
  enum status: { open: 1, completed: 2, inprogress: 3, cancelled: 4}
  belongs_to_account
  belongs_to :agent, optional: true
  belongs_to :appointment, optional: true
  
  before_create :assign_default_values
  before_update :save_appt_timings
  validates_uniqueness_of :agent_id, scope: :appointment_id

  scope :unattended, -> { where("status = ?",AgentAppointment.statuses[:open])}
  scope :completed, -> { where("status = ?",AgentAppointment.statuses[:completed])}
  scope :inprogress, -> { where("status = ?",AgentAppointment.statuses[:inprogress])}
  scope :unclosed, -> { where("status NOT IN (?)", [AgentAppointment.statuses[:completed], AgentAppointment.statuses[:cancelled]])}
  scope :agent_touched, -> { where("status NOT IN (?)",[AgentAppointment.statuses[:open], AgentAppointment.statuses[:cancelled]])}
  scope :future_appts, -> { joins(:appointment).where('appointments.start_time > ?', Time.now) }

  private
    def assign_default_values
      self.status = 'open'
    end

    def save_appt_timings
      self.checkin_at = Time.now if self.status == 'inprogress' && self.status_was == 'open'
      self.checkout_at = Time.now if self.status == 'completed' && self.status_was == 'inprogress'
    end
end
