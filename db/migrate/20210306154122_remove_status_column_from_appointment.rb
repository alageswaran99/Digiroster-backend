class RemoveStatusColumnFromAppointment < ActiveRecord::Migration[6.0]
  def change
    remove_column :appointments, :status
    remove_column :appointments, :agent_id
  end
end
