class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :primary,  reading: :primary_replica } 

  before_validation :set_current_account, on: :create, if: proc { self.attributes.keys.include?('account_id') }
  validates_presence_of :account_id, if: proc { self.attributes.keys.include?('account_id') }

  # ActiveRecord::Base.connected_to(role: :reading) do
  # end

  def api_format
    self.decorate.class.new(self).api_decorate
  end

  def mini_api_format
    self.decorate.class.new(self).mini_api_decorate
  end

  def current_acc_user
    User.current
  end

  def current_account
    Account.current
  end

  def set_current_account
    if self.account_id.nil? && current_account
      self.account_id = current_account.id
    end
    if current_account.nil?
      Rails.logger.info("WARNING :: Account.current is nil for the model #{self.class.name}")
    end
  end
end
