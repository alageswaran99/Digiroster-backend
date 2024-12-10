class AddColumnToAllowlistJwt < ActiveRecord::Migration[6.0]
  def change
    add_column :allowlisted_jwts, :allowlisted_jwt_id, :bigint
  end
end
