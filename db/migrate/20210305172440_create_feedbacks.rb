class CreateFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.bigint :client_id
      t.bigint :agent_id
      t.bigint :account_id
      t.jsonb :other_info
      t.text :description
      t.bigint :appointment_id
      t.integer :note_type

      t.timestamps
    end
  end
end
