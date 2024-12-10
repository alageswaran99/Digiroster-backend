class Account < ApplicationRecord
  store_accessor :contact_info, :first_name, :last_name, :email, :mobile

  has_many :appointments
  has_many :agent_appointments
  has_many :roles
  has_many :agents
  has_many :users
  has_many :groups
  has_many :clients
  has_many :regions
  has_many :feedbacks
  has_many :holidays
  has_many :notes
  has_many :deferred_jobs, :as => :job_owner, :class_name => "::Delayed::Job"
  has_many :recurring_tasks
  has_one :domain, class_name: 'DomainMapping'

  before_create :assign_auth_secret

  validates_uniqueness_of :full_domain

  class << self # class methods

    def reset_current_account
      Thread.current[:account] = nil
    end

    def current
      Thread.current[:account]
    end
  end

  def make_current
    Thread.current[:account] = self
  end

  def external_url(path = '')
    "http://#{self.domain.domain}#{path}"
  end

  private
  
    def assign_auth_secret
      self.auth_secret = SecureRandom.hex(15)
    end
end
