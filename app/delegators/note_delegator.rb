class NoteDelegator < BaseDelegator
  validate :check_note_params, if: -> { [:create, :update].include?(current_context) }
  validate :appointment_client_info, if: -> { [:create, :update].include?(current_context) }

  CONTEXT_ACTION_MAPPING = {
    create: :check_create_params,
    update: :check_create_params # currently just using same as create
  }

  def initialize(params, options = {})
    @params = params
    @current_context = options[:context]
    super(params, options)
  end

  def appointment_client_info
    return if params[:note][:appointment_id].blank?

    appt = current_user.appointments.find_by_id(params[:note][:appointment_id])
    
    if appt.blank?
      errors.add("Invalid params", "Invalid appointment ID")
      return
    end

    return if params[:note][:client_id].blank?

    unless appt.client_id == params[:note][:client_id].to_i
      errors.add("Invalid params", "Invalid client ID for given appointment")
    end
  end

  def check_note_params
    begin
      public_send CONTEXT_ACTION_MAPPING[@current_context]
    rescue Exception => e
      errors.add("Invalid attributes", e)
    end
  end

  def check_create_params
    param! :note, Hash do |note_param|
      note_param.param! :data, String, blank: false, required: true
      note_param.param! :client_id, Integer
      note_param.param! :appointment_id, Integer
    end
  end
end