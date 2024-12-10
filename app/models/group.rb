class Group < ApplicationRecord
  belongs_to_account
  has_many :agents
  has_many :clients
  belongs_to :created_by, class_name: "Agent", optional: true
  
  before_destroy :un_assign, prepend: true
  before_create :set_default_data
  

  enum group_type: { client: 1, agent: 2}
  filter_by :group_type
  validates_uniqueness_of :name, scope: [:account_id, :group_type]
  validate :name_not_changed

  scope :ex_client, -> { where(name: 'Ex Clients', group_type: 1).first}
  scope :ex_agent, -> { where(name: 'Ex Agents', group_type: 2).first}

  private

    def un_assign
      if is_system_generated?
        errors.add(:name, "System generated should not be deleted!!")
        throw :abort
      else
        self.agents.update_all(group_id: nil)
        self.clients.update_all(group_id: nil)
      end
    end

    def name_not_changed
      if name_changed? && self.persisted? && is_system_generated?
        errors.add(:name, "Default group name edit not allowed.")
      end
    end

    def is_system_generated? 
      (self.name_was == 'Ex Clients' && self.group_type == Group.group_types.invert[1]) || (self.name_was == 'Ex Agents' && self.group_type == Group.group_types.invert[2])
    end

    def set_default_data
      self.created_by ||= User.current
    end
end
