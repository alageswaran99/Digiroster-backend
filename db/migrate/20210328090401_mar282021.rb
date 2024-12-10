class Mar282021 < ActiveRecord::Migration[6.0]
  def change
    remove_column :appointments, :created_by
    remove_column :recurring_tasks, :created_by
    add_column :appointments, :created_by_id, :bigint
    add_column :recurring_tasks, :created_by_id, :bigint
  end
end
