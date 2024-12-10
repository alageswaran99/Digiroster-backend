class AddColumnToRegion < ActiveRecord::Migration[6.0]
  def change
    add_column :regions, :address, :text
    add_column :regions, :phone, :string
    add_column :regions, :email, :string
    add_column :regions, :other_info, :text
  end
end
