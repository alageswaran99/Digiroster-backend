class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :full_domain
      t.string :time_zone
      t.string :plan_features
      t.integer :account_type
      t.jsonb :contact_info, default: {}, null: false
      
      t.timestamps
    end
    add_index :accounts, [:full_domain], unique: true
  end
end
