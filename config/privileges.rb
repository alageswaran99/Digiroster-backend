# require_relative 'api_privileges'
Authority::Authorization::PrivilegeList.build do

  manage_account do
    resource :"note"
    resource :"group"
    resource :"appointment"
    resource :"client"
    resource :"agent"
    resource :"role"
    resource :"region"
    resource :"feedback"
    resource :"holiday", only: [:index, :show]
    resource :"account", only: [:dashboard]
  end

  carer_view do
    resource :"note", only: [:index, :show, :create, :update]
    resource :"appointment", :only => [:carer_appointments, :update_progress, :close_appointment]
    resource :"agent", :only => [:change_password]
    resource :"holiday", only: [:index, :show, :create]
  end

  manage_users do
    resource :"user"
  end

  # client_manager do
  # end

  # contractor do
  # end
  # Authority::Authorization::PrivilegeList.privileges.each { |privilege| puts privilege}

end
