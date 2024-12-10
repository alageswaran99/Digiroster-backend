class ClientDelegator < BaseDelegator

  validate :validate_region_ids, if: -> { [:create, :update].include?(current_context) }
  validate :check_client_params, if: -> { [:create, :update].include?(current_context) }
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
    return if params[:client][:group_id].blank?

    _group = current_account.groups.by_group_type('client').find_by_id(params[:client][:group_id])
    if _group.blank?
      errors.add("Invalid params", "Invalid group_id for clients")
    end
  end

  def validate_region_ids
    if current_context == :create && params[:client][:region_ids].blank?
      errors.add("Invalid params", "region_ids must exist for create")
      return
    end
    return true if params[:client][:region_ids].blank?

    db_count = current_account.regions.where(id: params[:client][:region_ids]).count
    if db_count == params[:client][:region_ids].size
      return true
    else
      errors.add("Invalid params", "some of the region_ids are invalid")
    end
  end

  def check_client_params
    begin
      public_send CONTEXT_ACTION_MAPPING[@current_context]
    rescue Exception => e
      errors.add("Invalid attributes", e)
    end
  end

  def check_create_params
    param! :client, Hash do |client_param|
      client_param.param! :title, Integer, in: Client::TITLE_MAPPINGS.values, required: true
      client_param.param! :gender, Integer, in: Client::GENDER_MAPPINGS.values, required: true
      client_param.param! :first_name, String, blank: false, required: true
      client_param.param! :last_name, String, blank: false, required: true
      client_param.param! :middle_name, String
      client_param.param! :dob, String
      client_param.param! :address, String
      client_param.param! :phone, String
      client_param.param! :keynote, String
      client_param.param! :group_id, Integer, blank: false
      client_param.param! :email, String, blank: false
      client_param.param! :services, Array
    end
  end

  def check_update_params
    param! :client, Hash do |client_param|
      client_param.param! :title, Integer, in: Client::TITLE_MAPPINGS.values, blank: false
      client_param.param! :gender, Integer, in: Client::GENDER_MAPPINGS.values, blank: false
      client_param.param! :first_name, String, blank: false
      client_param.param! :last_name, String, blank: false
      client_param.param! :middle_name, String
      client_param.param! :dob, String
      client_param.param! :address, String
      client_param.param! :phone, String
      client_param.param! :keynote, String
      client_param.param! :group_id, Integer, blank: false
      client_param.param! :email, String, blank: false
      client_param.param! :services, Array
    end
  end
end