class Region < ApplicationRecord
  belongs_to_account

  has_many :clients
  has_many :agents

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :account_id
end
