class CreateDomainMappings < ActiveRecord::Migration[6.0]
  def change
    create_table :domain_mappings, :primary_key => :account_id do |t|
      t.string :domain
    end
    add_index :domain_mappings, [:domain], unique: true
  end
end
