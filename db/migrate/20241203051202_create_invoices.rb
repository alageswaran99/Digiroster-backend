class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.string :invoiceId
      t.string :clientId
      t.string :groupId
      t.string :regionId
      t.string :timePeriod
      t.integer :durationtype
      t.integer :customizedCheckbox
      t.decimal :ratePerMinute
      t.datetime :invoiceDate
      t.integer :account_id
      t.decimal :grand_totalamount
      t.decimal :grand_total_minutes

      t.timestamps
    end
  end
end
