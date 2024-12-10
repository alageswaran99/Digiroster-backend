class ApplicationController < ActionController::API
  include DecoratorConcern
  include ExceptionHandler
  include PagyCustomHelper

  before_action :set_default_response_format
  #dont change order!!
  before_action :clear_request_cookies, :unset_current_account, :set_current_account, :authenticate_user!, :set_current_user
  # before_action :authenticate_user!
  after_action :clear_thread_variables, :clear_response_cookies
  # before_action :unset_current_account, :set_current_account, :authenticate_user!, :set_current_user
  # after_action :clear_thread_variables
  before_action :check_privilege
  include Authority::FreshcareRails::ControllerHelpers
  
  def current_account
    @current_account ||= retrieve_current_account
  end

  # def validate_token
  #   return true if Rails.env.development?
  #   Rails.logger.info("In validate token !!!")
  #   if !(request.headers[:token] == ENV['AUTH_TOKEN'])
  #     raise CustomErrors::Unauthorized, 'Not Authenticated'
  #   end
  # end

  def current_acc_user
    @current_user ||= User.current
  end

  def access_denied(msg = 'Not Authenticated OR Unauthorized')
    raise CustomErrors::Unauthorized, msg
  end

  private

    def set_default_response_format
      request.format = :json
    end

    def clear_request_cookies
      request.cookies.delete("_interslice_session")
    end

    def clear_response_cookies
      response.cookies.delete("_interslice_session")
    end

    def unset_current_account
      Thread.current[:account] = nil
      Thread.current[:user] = nil
    end

    def set_current_account
      current_account.make_current
    end

    def set_current_user
      current_user.make_current if current_user
    end

    def current_agent
      current_account.agents.find(current_user.id)
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
