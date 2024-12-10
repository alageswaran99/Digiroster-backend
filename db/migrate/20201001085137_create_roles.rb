class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :privileges
      t.text :description
      t.boolean :default_role, :default => false
      t.bigint :account_id

      t.timestamps
    end
  end
end
