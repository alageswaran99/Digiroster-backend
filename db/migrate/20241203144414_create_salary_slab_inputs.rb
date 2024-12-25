# db/migrate/xxxx_create_salary_slab_inputs.rb
class CreateSalarySlabInputs < ActiveRecord::Migration[7.0]
  def change
    create_table :salary_slab_inputs do |t|
      t.references :salary, null: false, foreign_key: true
      t.decimal :rate, precision: 10, scale: 2

      t.timestamps
    end
  end
end
