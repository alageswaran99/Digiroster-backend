class RemoveColumnFromAppointment < ActiveRecord::Migration[6.0]
  def change
    remove_column :appointments, :recurring_appointment
    add_column :appointments, :recurring_task_id, :bigint
  end
end
