class CreateAllowlistedJwts < ActiveRecord::Migration[6.0]
  def change
    create_table :allowlisted_jwts do |t|
      t.string :jti
      t.string :aud
      t.integer :session_type
      t.datetime :exp
      t.bigint :account_id
      t.bigint :user_id

      t.timestamps
    end

    add_index :allowlisted_jwts, [:account_id, :jti],                unique: true
    add_index :allowlisted_jwts, [:account_id, :user_id]
  end
end
