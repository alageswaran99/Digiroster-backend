class AddGroupToClient < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :group_id, :bigint
  end
end
