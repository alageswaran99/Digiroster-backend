class AddColumnToDelayedJob < ActiveRecord::Migration[6.0]
  def change
    add_column :delayed_jobs, :job_owner_id, :bigint
    add_column :delayed_jobs, :job_owner_type, :string
  end
end
