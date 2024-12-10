class User < ApplicationRecord
  include User::JwtAuthUtil
  include User::Constants, User::PrivilegesUtil
  include Authority::FreshcareRails::ModelHelpers
  include Devise::JWT::RevocationStrategies::Allowlist

  store_accessor :other_info, :title, :gender, :landline, :address, :postcode, :dob, :middle_name, :role_ids, :map_data

  # Include default devise modules. Others available are:  :omniauthable
  devise :database_authenticatable, :recoverable, :validatable, 
    :confirmable, :lockable, :timeoutable, :trackable,:jwt_authenticatable, jwt_revocation_strategy: self

  belongs_to_account
  has_many :allowlisted_jwts

  before_validation :check_password, on: :create
  validates_uniqueness_of :email, scope: :account_id
  validates_format_of :email, :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  validates_presence_of :password, :on=>:create
  validates_confirmation_of :password, :on=>:create
  validates_length_of :password, :within => Devise.password_length, :allow_blank => true

  #start of class methods
  class << self

    def reset_current_user
      Thread.current[:user] = nil
    end

    def current
      Thread.current[:user]
    end
  end

  # end of class methods

  def self.jwt_revoked?(payload, user)
    !user.allowlisted_jwts.exists?(payload.slice('jti', 'aud'))
  end

  # @see Warden::JWTAuth::Interfaces::RevocationStrategy#revoke_jwt
  def self.revoke_jwt(payload, user)
    jwt = user.allowlisted_jwts.find_by(payload.slice('jti', 'aud'))
    jwt.destroy! if jwt
  end

  # Warden::JWTAuth::Interfaces::User#on_jwt_dispatch
  def on_jwt_dispatch(_token, payload)
    allowlisted_jwts.create!(
      jti: payload['jti'],
      aud: payload['aud'],
      exp: Time.at(payload['exp'].to_i)
    )
  end

  def roles
    acc = Account.current || self.account
    acc.roles.where(id: self.role_ids.to_a)
  end

  def carer?
    self.roles.pluck(:name).include?("Carer")
  end

  def make_current
    Thread.current[:user] = self
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def check_password
    self.skip_confirmation!
    unless self.encrypted_password_came_from_user?
      # system_password = SecureRandom.base64(12)
      system_password = "Password1!"
      self.password = system_password
      self.password_confirmation = system_password
    end
  end

  def full_name
    "#{self.first_name} #{self.middle_name} #{self.last_name}"
  end

  def send_confirmation_notification?
    false
  end

  def full_name_with_title
    "#{TITLE_MAPPINGS.key(self.title)} #{self.first_name} #{self.middle_name} #{self.last_name}".squish
  end

  def gender_as_readable
    GENDER_MAPPINGS.key(self.gender)
  end
end
