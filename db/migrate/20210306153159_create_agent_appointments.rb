class CreateAgentAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :agent_appointments do |t|
      t.bigint :agent_id
      t.bigint :appointment_id
      t.bigint :account_id
      t.integer :status

      t.timestamps
    end
  end
end
