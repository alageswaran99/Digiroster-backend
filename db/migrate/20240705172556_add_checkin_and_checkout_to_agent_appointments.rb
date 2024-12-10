class AddCheckinAndCheckoutToAgentAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :agent_appointments, :checkin_at, :timestamp
    add_column :agent_appointments, :checkout_at, :timestamp
  end
end
