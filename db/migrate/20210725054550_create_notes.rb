class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.bigint :agent_id
      t.bigint :client_id
      t.text :data
      t.bigint :account_id

      t.timestamps
    end
  end
end
