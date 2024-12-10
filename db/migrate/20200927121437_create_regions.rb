class CreateRegions < ActiveRecord::Migration[6.0]
  def change
    create_table :regions do |t|
      t.bigint "account_id"
      t.string "name"
      t.timestamps
    end
  end
end
