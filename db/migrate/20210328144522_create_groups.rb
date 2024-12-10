class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.bigint :account_id
      t.text :description
      t.integer :group_type
      t.bigint :created_by_id
      t.timestamps
    end
  end
end
