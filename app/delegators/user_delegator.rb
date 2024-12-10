class UserDelegator < BaseDelegator

  # validate :validate_rm_attendees, :validate_contact_attendees, if: -> { [:create, :update].include?(current_context) }
  validate :check_region_params, if: -> { [:create, :update].include?(current_context) }

  CONTEXT_ACTION_MAPPING = {
    create: :check_create_params,
    update: :check_create_params # currently just using same as create
  }

  def initialize(params, options = {})
    @params = params
    @current_context = options[:context]
    super(params, options)
  end

  def check_region_params
    begin
      public_send CONTEXT_ACTION_MAPPING[@current_context]
    rescue Exception => e
      errors.add("Invalid attributes", e)
    end
  end

  def check_create_params
    param! :region, Hash do |region_param|
      region_param.param! :name, String, blank: false, required: true
      region_param.param! :address, String
      region_param.param! :phone, String
      region_param.param! :email, String
    end
  end
end