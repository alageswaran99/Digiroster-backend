class HolidayDelegator < BaseDelegator
  validate :check_holiday_params, if: -> { [:create, :update, :index].include?(current_context) }
  validate :check_for_future_appointments, if: -> { [:create, :update].include?(current_context) }

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

  def check_holiday_params
    begin
      public_send CONTEXT_ACTION_MAPPING[@current_context]
    rescue Exception => e
      errors.add("Invalid attributes", e)
    end
  end

  def check_for_future_appointments
    Rails.logger.info("check_for_future_appointments...")
    holiday_start = params[:holiday][:from_time]
    holiday_end = params[:holiday][:to_time]
    date_list = (holiday_start..holiday_end).map{ |_date| _date }
    date_list.each do |_current_date|
      if Holiday.check_appoinment(current_user, _current_date)
        errors.add("error", "Appointment exist for the date #{_current_date}")
        break
      end
    end
  end

  def check_create_params
    param! :holiday, Hash do |holiday_param|
      holiday_param.param! :reason, String, blank: false
      holiday_param.param! :from_time, Date, blank: false, required: true
      holiday_param.param! :to_time, Date, blank: false, required: true
    end
    check_for_future_appointments
  end

  def check_update_params
    param! :holiday, Hash do |holiday_param|
      holiday_param.param! :reason, String, blank: false
      holiday_param.param! :from_time, Date, blank: false
      holiday_param.param! :to_time, Date, blank: false
    end
  end

  def check_filter_params
    return if params[:filter].blank?
  end
end