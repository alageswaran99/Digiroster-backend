class AgentDelegator < BaseDelegator
  validate :validate_region_ids, :validate_role_ids, if: -> { [:create, :update].include?(current_context) }
  validate :check_agent_params, if: -> { [:create, :update].include?(current_context) }
  validate :check_group_id

  CONTEXT_ACTION_MAPPING = {
    create: :check_create_params,
    update: :check_update_params
  }

  def initialize(params, options = {})
    @params = params
    @current_context = options[:context]
    super(params, options)
  end

  def check_group_id
    return if params[:agent][:group_id].blank?

    _group = current_account.groups.by_group_type('agent').find_by_id(params[:agent][:group_id])
    if _group.blank?
      errors.add("Invalid params", "Invalid group_id for agents")
    end
  end

  def validate_role_ids
    if current_context == :create && params[:agent][:role_ids].blank?
      errors.add("Invalid params", "role_ids must exist for create")
      return false
    end

    return true if params[:agent][:role_ids].nil?

    if params[:agent][:role_ids].size.zero?
      errors.add("Invalid params", "Roles are mandatory")
      return false
    end

    db_count = current_account.roles.where(id: params[:agent][:role_ids]).count
    if db_count == params[:agent][:role_ids].size
      return true
    else
      errors.add("Invalid params", "some of the role_ids are invalid")
    end
  end

  def validate_region_ids
    if current_context == :create && params[:agent][:region_ids].blank?
      errors.add("Invalid params", "region_ids must exist for create")
      return
    end
    return true if params[:agent][:region_ids].blank?

    db_count = current_account.regions.where(id: params[:agent][:region_ids]).count
    if db_count == params[:agent][:region_ids].size
      return true
    else
      errors.add("Invalid params", "some of the region_ids are invalid")
    end
  end

  def check_agent_params
    begin
      public_send CONTEXT_ACTION_MAPPING[@current_context]
    rescue Exception => e
      errors.add("Invalid attributes", e)
    end
  end

  def check_create_params
    param! :agent, Hash do |agent_param|
      agent_param.param! :title, Integer, in: Agent::TITLE_MAPPINGS.values, required: true
      agent_param.param! :gender, Integer, in: Agent::GENDER_MAPPINGS.values, required: true
      agent_param.param! :first_name, String, blank: false, required: true
      agent_param.param! :last_name, String, blank: false, required: true
      agent_param.param! :middle_name, String
      agent_param.param! :dob, String
      agent_param.param! :address, String
      agent_param.param! :phone, String
      agent_param.param! :group_id, Integer, blank: false
      agent_param.param! :email, String, blank: false
    end
  end

  def check_update_params
    param! :agent, Hash do |agent_param|
      agent_param.param! :title, Integer, in: Agent::TITLE_MAPPINGS.values, blank: false
      agent_param.param! :gender, Integer, in: Agent::GENDER_MAPPINGS.values, blank: false
      agent_param.param! :first_name, String, blank: false
      agent_param.param! :last_name, String, blank: false
      agent_param.param! :middle_name, String
      agent_param.param! :dob, String
      agent_param.param! :address, String
      agent_param.param! :phone, String
      agent_param.param! :group_id, Integer, blank: false
      agent_param.param! :email, String, blank: false
    end
  end
end