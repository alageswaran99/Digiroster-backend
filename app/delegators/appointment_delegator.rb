class AppointmentDelegator < BaseDelegator

  validate :validate_client_id, :validate_agent_id, :validate_appt_time, if: -> { [:create, :update].include?(current_context) }
  validate :check_appoinment_params, if: -> { [:create, :update, :carer_appointments, :update_progress, :cancel_appointment].include?(current_context) }
  validate :validate_scheduled_days, if: -> { [:create_recurring].include?(current_context) }
  # validates :check_agent_ids, if: -> { [:create, :update].include?(current_context) }

  CONTEXT_ACTION_MAPPING = {
    create:             :check_create_params,
    update:             :check_update_params,
    carer_appointments: :check_carer,
    update_progress:    :check_progress,
    cancel_appointment: :check_cancel_note
  }
  
  def initialize(params, options = {})
    @params = params
    @current_context = options[:context]
    super(params, options)
  end

  def validate_scheduled_days
    return if params.dig(:appointment, :scheduled_days).blank?

    result = params.dig(:appointment, :scheduled_days).select do |x|
      x > 6 || x < 0
    end
    errors.add("Invalid params", "Invalid scheduled days #{result} Permitted from 0 to 6") if result.length.nonzero?
  end

  def check_cancel_note
    
    if params.dig(:appointment, :cancel_note).blank?
      return errors.add("Invalid params", "cancel_note must present")
    end

    appointment = current_account.appointments.find_by_id(params[:id])

    if appointment && appointment.cancelled?
      return errors.add("Invalid params", "Appointment already cancelled")
    elsif appointment && !appointment.allow_edit?
      return errors.add("Invalid params", "Appointment Not in Open state")
    end

    true
  end

  def check_agent_ids
    # if params[:agent_appointments_attributes].present?
      
    # end
    
  end

  def validate_appt_time
    # return if current_context == :update && params[:appointment][:start_time].blank? && params[:appointment][:end_time].blank?

    
  end

  def check_progress
    Rails.logger.info("checkin_params ::: #{checkin_params.inspect}")
    # appointment = current_account.appointments.find(params[:id])
    # unless CareTaker::Checkin.new(checkin_params, appointment).can_checkin?
    #   errors.add("CheckIn not allowed", "Too far to checkin")
    # end
  end

  def validate_client_id
    return if current_context == :update && params[:appointment][:client_id].blank?
    
    return if current_account.clients.find_by_id(params[:appointment][:client_id]).present?

    errors.add("Invalid params", "Invalid client_id")
  end

  def validate_agent_id
    # return if current_context == :update && params[:appointment][:agent_id].blank?
    
    # return if Account.current.agents.find_by_id(params[:appointment][:agent_id]).present?

    # errors.add("Invalid params", "Invalid agent_id")
  end

  def check_carer
    unless current_user.carer?
      errors.add("Not a valid carer!", "Assign carer role first")
    end
  end

  def check_appoinment_params
    begin
      public_send CONTEXT_ACTION_MAPPING[@current_context]
    rescue Exception => e
      errors.add("Invalid attributes", e)
    end
  end

  def check_create_params
    param! :appointment, Hash do |appt_param|
      appt_param.param! :client_id, Integer, blank: false, required: true
      appt_param.param! :notes, String, blank: false
      appt_param.param! :start_time, DateTime, blank: false, required: true
      appt_param.param! :end_time, DateTime, blank: false, required: true
      appt_param.param! :task_end_date, DateTime, blank: false
      appt_param.param! :services, Array
      appt_param.param! :scheduled_days, Array
      appt_param.param! :agent_appointments_attributes, Array
    end
  end

  def check_update_params
    param! :appointment, Hash do |appt_param|
      appt_param.param! :client_id, Integer, blank: false
      appt_param.param! :notes, String, blank: false
      appt_param.param! :start_time, DateTime, blank: false
      appt_param.param! :end_time, DateTime, blank: false
      appt_param.param! :task_end_date, DateTime, blank: false
      appt_param.param! :services, Array
      appt_param.param! :agent_appointments_attributes, Array
    end
  end

  def checkin_params
    params.require(:appointment).permit(map_data: [:lat, :lng])
  end

end