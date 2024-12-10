class CreateAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :appointments do |t|
      t.bigint :client_id
      t.bigint :agent_id
      t.bigint :account_id
      t.jsonb :other_info
      t.text :notes
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
