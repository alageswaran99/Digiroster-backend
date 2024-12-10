class Holiday < ApplicationRecord
  belongs_to_account
  belongs_to :agent

  before_create :set_leave_type

  # def self.check_appoinment(agent_id, check_for_date)
  #   res = Account.current.agent_appointments.joins(:appointment).where("status != ? AND agent_id = ? AND 
  #   appointments.start_time::date = ? OR appointments.end_time::date = ?", 
  #   AgentAppointment.statuses[:completed], agent_id, check_for_date, check_for_date)
  #   false
  # end

  def self.check_appoinment(agent_obj, check_for_date)
    agent_obj.agent_appointments.unclosed.joins(:appointment).where(
      "appointments.start_time::date = ? OR appointments.end_time::date = ?", check_for_date, check_for_date).exists?
  end

  private

    def set_leave_type
      self.leave_type = 1
    end
end
