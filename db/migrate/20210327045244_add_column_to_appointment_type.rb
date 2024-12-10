class AddColumnToAppointmentType < ActiveRecord::Migration[6.0]
  def change
    add_column :appointments, :recurring, :boolean
    add_column :appointments, :created_by, :bigint
    add_column :appointments, :recurring_appointment, :bigint
  end
end
