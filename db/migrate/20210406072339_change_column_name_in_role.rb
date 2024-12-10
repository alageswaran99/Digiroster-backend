class ChangeColumnNameInRole < ActiveRecord::Migration[6.1]
  def change
    rename_column :roles, :default_role, :fc_default
  end
end
