class AlterColumnToUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :region_id, :int
    add_column :users, :region_ids, :text, array: true, default: []
    add_column :users, :username, :string
    remove_column :users, :name
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end
end
