class Users::PasswordsController < Devise::PasswordsController
  before_action :unset_current_account, :set_current_account

  respond_to :json

  def create
    if valid_user?
      super
    else
      access_denied
    end
  end

  def new

  end

  def edit

  end

  def update
    super
  end

  private

    def valid_user?
      c_user = current_account.users.find_by_email(params[:user][:email])
      c_user.is_a?(Client) ? false : true
    end

    def current_account
      @current_account ||= retrieve_current_account
    end

    def unset_current_account
      Thread.current[:account] = nil
      Thread.current[:user] = nil
    end

    def set_current_account
      current_account.make_current
    end

    def retrieve_current_account
      dm = DomainMapping.find_by_domain(request_host)
      return dm.account.make_current if dm
    
      raise CustomErrors::NotFound, 'Invalid Account'
    end

    def request_host
      @request_host ||= request.host.gsub('.api.', '.')
    end

    def clear_thread_variables
      Thread.current[:account] = nil
      Thread.current[:user] = nil
    end
end