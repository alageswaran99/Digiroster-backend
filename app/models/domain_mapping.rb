class DomainMapping < ApplicationRecord
  validates_uniqueness_of :domain

  belongs_to :shard, :class_name => 'ShardMapping', :foreign_key => :account_id
  belongs_to :account, :class_name => 'Account', :foreign_key => :account_id #have to remove this once we enable sharding
end
