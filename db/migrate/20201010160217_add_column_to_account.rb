class AddColumnToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :auth_secret, :string
  end
end
