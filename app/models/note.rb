class Note < ApplicationRecord
  belongs_to_account
  belongs_to :agent
  belongs_to :client, optional: true
  belongs_to :appointment, optional: true
end
