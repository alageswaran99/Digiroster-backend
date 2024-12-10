class AllowlistedJwt < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Allowlist

  self.primary_key = :id
  belongs_to_account
  belongs_to :user
end
