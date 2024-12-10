class AddColumnToAppt < ActiveRecord::Migration[6.1]
  def change
    add_column :appointments, :appt_status, :integer, :default => 1
  end
end
