class CreateHolidays < ActiveRecord::Migration[6.1]
  def change
    create_table :holidays do |t|
      t.bigint :agent_id
      t.bigint :account_id
      t.text :reason
      t.datetime :from_time
      t.datetime :to_time
      t.integer :leave_type

      t.timestamps
    end
  end
end
