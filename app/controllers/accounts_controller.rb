class AccountsController < ApplicationController

  def dashboard
    res = {
      total_appointment: current_account.appointments.count,
      total_clients: current_account.clients.count,
      pending_appointments:  current_account.agent_appointments.unclosed.count,
      total_carers: carer_count
    }
    render :json => res
  end

  private

    def carer_count
      counter = 0
      carer_role_id = Account.current.roles.find_by_name('Carer').try(:id)
      return 0 if carer_role_id.nil?
      
      current_account.agents.find_each do |x|
        if x.role_ids.include?(carer_role_id)
          counter += 1
        end
      end
      counter
    end
end
