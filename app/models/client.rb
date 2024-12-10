class Client < User
  store_accessor :other_info, :services, :keynote
  belongs_to_account
  belongs_to :group, optional: true
  before_save :assign_default_role, :set_default_role
  before_create :skip_email_notification

  has_many :appointments
  has_many :recurring_appointments, class_name: "RecurringTask"
  has_many :feedbacks
  has_many :notes
  has_one_attached :general_file

  def assign_default_role
    self.privileges = 0
    if self.services_changed?
      self.services = self.services.map { |e| e.capitalize  }
    end
  end

  def set_default_role
    client_role_id = Account.current.roles.find_by_name("Client").id
    self.role_ids = [client_role_id]
  end

  def skip_email_notification
    self.skip_confirmation!
  end

  def make_inactive
    self.group = Account.current.groups.ex_client
    self.save
    self.recurring_appointments.destroy_all
    self.appointments.upcoming.destroy_all
    self.soft_delete
  end
end
