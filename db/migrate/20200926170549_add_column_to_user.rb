class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :other_info, :jsonb
    add_column :users, :region_id, :int
  end
end
