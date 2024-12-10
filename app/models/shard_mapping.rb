class ShardMapping < ApplicationRecord
  enum status: { inprogress: 206, ok: 200, not_found: 404, blocked: 403, maintenance: 503 }

  has_many :domains, class_name: 'DomainMapping', dependent: :destroy, foreign_key: :account_id
end
