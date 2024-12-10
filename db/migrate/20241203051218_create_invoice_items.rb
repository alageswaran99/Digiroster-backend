class CreateInvoiceItems < ActiveRecord::Migration[7.0]
  def change
    create_table :invoice_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.date :date
      t.decimal :quantity
      t.string :description
      t.decimal :unitPrice
      t.decimal :amount

      t.timestamps
    end
  end
end
