class PopulateSeed27Jun2021 < ActiveRecord::Migration[6.1]
  def change
    Account.find_each do |account|
      begin
        account.make_current
        client_group = Account.current.groups.new({name: 'Ex Clients', description: 'Default client group created by system', group_type: 1})
        client_group.save
        agent_group = Account.current.groups.new({name: 'Ex Agents', description: 'Default agent group created by system', group_type: 2})
        agent_group.save
      rescue Exception => e
        puts ('Something went wrong while data population')
        Rails.logger.debug('Something went wrong while data population')
      ensure
        Account.reset_current_account
      end
    end
  end
end
