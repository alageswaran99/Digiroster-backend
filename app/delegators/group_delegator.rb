class GroupDelegator < BaseDelegator
  validate :check_group_params, if: -> { [:create, :update, :index].include?(current_context) }

  CONTEXT_ACTION_MAPPING = {
    create: :check_create_params,
    update: :check_update_params, # currently just using same as create
    index: :check_filter_params
  }

  def initialize(params, options = {})
    @params = params
    @current_context = options[:context]
    super(params, options)
  end

  def check_group_params
    begin
      public_send CONTEXT_ACTION_MAPPING[@current_context]
    rescue Exception => e
      errors.add("Invalid attributes", e)
    end
  end

  def check_create_params
    param! :group, Hash do |group_param|
      group_param.param! :name, String, blank: false, required: true
      group_param.param! :description, String, blank: false
      group_param.param! :group_type, String, in: Group.group_types.keys, required: true
    end
  end

  def check_update_params
    param! :group, Hash do |group_param|
      group_param.param! :name, String, blank: false
      group_param.param! :description, String, blank: false
      group_param.param! :group_type, String, in: Group.group_types.keys, blank: false
    end
  end

  def check_filter_params
    return if params[:filter].blank?

    if Group.group_types.keys.include?(params[:filter][:by_group_type].first) && params[:filter][:by_group_type].size == 1
      return
    else
      errors.add("Invalid param", "Allowed only #{Group.group_types.keys}")
    end
  end
end