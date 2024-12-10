class AddColumnToRecurringTask < ActiveRecord::Migration[6.0]
  def change
    add_column :recurring_tasks, :task_end_date, :datetime
    remove_column :recurring_tasks, :agent_id
  end
end
