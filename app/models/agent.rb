class Agent < User
  belongs_to_account
  belongs_to :group, optional: true
  before_save :assign_privileges

  has_many :agent_appointments
  has_many :appointments, through: :agent_appointments
  # has_many :unclosed_appointments, through: :agent_appointments, :conditions => {:project_members => {:admin => true}}
  has_many :feedbacks
  has_many :holidays
  has_many :notes
  has_one_attached :general_file

  def assign_privileges
    assign_roles_privileges(self.role_ids)
  end

  def check_clash(start_time, end_time)
    # self.appointments.where(agent_id: self.agent_id, start_time:)
  end

  def working_hours
    x1 = DateTime.now.at_beginning_of_month
    y1 = DateTime.now.at_beginning_of_month.next_month
    appts = self.appointments.where("start_time > ? AND start_time < ?", x1, y1)
    total_seconds = 0
    appts.each do |x|
      total_seconds += (x.end_time - x.start_time)
    end
    total_seconds/3600 # converting to hours
  end

  def make_inactive
    self.group = Account.current.groups.ex_agent
    self.save
    self.agent_appointments.future_appts.destroy_all
    self.soft_delete
    Rails.logger.info("Making Inactive")
    Account.current.recurring_tasks.each do |rec_appt|
      if rec_appt.agent_ids && rec_appt.agent_ids.include?(self.id)
        rec_appt.job_not_needed = true
        rec_appt.agent_ids = rec_appt.agent_ids - [self.id]
        rec_appt.save
      end
    end
  end

  def formatted_duration(total_minute)
    hours = total_minute / 60
    minutes = (total_minute) % 60
    "#{ hours }h #{ minutes }min"
  end
end