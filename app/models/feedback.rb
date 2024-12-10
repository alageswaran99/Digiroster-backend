class Feedback < ApplicationRecord
  store_accessor :other_info, :services

  belongs_to_account
  belongs_to :agent
  belongs_to :client
  belongs_to :appointment, optional: true
  default_scope -> { order(created_at: :desc) }
  
  enum note_type: { accident: 1, compliment: 2, notes: 3, complaint: 4, general: 5}

  filter_by :client_id, :agent_id, :appointment_id, :note_type
end
