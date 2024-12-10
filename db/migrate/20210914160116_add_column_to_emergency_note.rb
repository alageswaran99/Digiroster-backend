class AddColumnToEmergencyNote < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :appointment_id, :bigint
  end
end
