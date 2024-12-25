class CreateSalaries < ActiveRecord::Migration[7.0]
  def change
    create_table :salaries do |t|
      t.string :salary_id
      t.string :carer_id
      t.string :group_id
      t.string :region_id
      t.string :time_period
      t.boolean :customized_checkbox, default: false
      t.integer :account_id

      t.timestamps
    end
  end
end