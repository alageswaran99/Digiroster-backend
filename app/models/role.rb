class Role < ApplicationRecord
  # alias_attribute :custom_default_role, :fc_default

  include Authority::FreshcareRails::ModelHelpers
  belongs_to_account

  scope :default_roles, -> { where(custom_default_role: true) }
  scope :custom_roles, -> { where(custom_default_role: false) }

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :account_id

  DEFAULT_ROLES = {
    :account_administrator => [:manage_account],
    :administrator => [:manage_account],
    :carer => [:carer_view],
    :client => []#this needs to be changed in client model before save also
  }

  def privilege_list=(privilege_data)
    privilege_data = privilege_data.collect {|p| p.to_sym unless p.blank?}.compact
    # Remove this check once new privileges list shown in UI
    # unless self.custom_default_role
    #   Helpdesk::PrivilegesMap::MIGRATION_MAP.each do |key,value|
    #       privilege_data.concat(value) if privilege_data.include?(key)
    #   end
    # end
    self.privileges = Role.privileges_mask(privilege_data.uniq).to_s
  end

  def privilege_list
      privileges = []
      PRIVILEGES_BY_NAME.each do |privilege|
        privileges.push(privilege) if self.privilege?(privilege)
      end
      privileges
  end

  def self.privileges_mask(privilege_data)
    (privilege_data & PRIVILEGES_BY_NAME).map { |r| 2**PRIVILEGES[r] }.sum
  end
end
