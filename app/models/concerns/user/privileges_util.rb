module User::PrivilegesUtil
  extend ActiveSupport::Concern
  
  def assign_roles_privileges(role_ids)
    return if role_ids.blank?

    received_roles = current_account.roles.where(id: role_ids)
    all_privileges = received_roles.map { |_role| _role.privilege_list }.flatten.uniq
    self.privilege_list = all_privileges
  end

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