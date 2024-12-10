class CreateSalarySlabInputs < ActiveRecord::Migration[6.0]
  def change
    create_table :salary_slab_inputs do |t|
      t.references :salary, null: false, foreign_key: true
      t.string :slab_id, null: false
      t.decimal :rate, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
