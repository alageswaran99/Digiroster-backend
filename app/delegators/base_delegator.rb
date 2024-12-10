class BaseDelegator < SimpleDelegator
  include ActiveModel::Validations
  include RailsParam
  
  attr_accessor :params, :current_context

  def initialize(record, options = {})
    super(record)
  end

  def current_account
    Account.current
  end

  def current_user
    User.current
  end
end
