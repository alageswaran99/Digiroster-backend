class PopulateAccountSeed

    def populate_for(account, user)
      account.make_current
      create_default_region
      config_default_roles(account)
      config_user_privileges(user)
    end

    def config_default_roles(account)
      Role::DEFAULT_ROLES.each do |_role, _privileges|
        db_role = account.roles.new(name: _role.to_s.titleize, custom_default_role: true)
        db_role.privilege_list = _privileges
        db_role.save
      end
    end

    def config_user_privileges(user)
      role = Account.current.roles.find_by(name: "Account Administrator")
      user.role_ids = [role.id]
      user.region_ids = [Account.current.regions.first.id]
      user.save
    end

    def create_default_region
      x = Account.current.regions.new({name: "Default"})
      x.save
    end

    def create_default_groups
      client_group = Account.current.groups.new({name: 'Default - Active Clients', description: 'Default client group created by system', group_type: 1})
      client_group.save
      client_group = Account.current.groups.new({name: 'Ex Clients', description: 'Default client group created by system', group_type: 1})
      client_group.save
      agent_group = Account.current.groups.new({name: 'Default - Active Agents', description: 'Default agent group created by system', group_type: 2})
      agent_group.save
      agent_group = Account.current.groups.new({name: 'Ex Agents', description: 'Default agent group created by system', group_type: 2})
      agent_group.save
    end
  
end