class CreateShardMappings < ActiveRecord::Migration[6.0]
  def change
    create_table :shard_mappings do |t|
      t.string :shard_name
      t.integer :status
      t.string :pod_info
      t.string :region
    end
  end
end