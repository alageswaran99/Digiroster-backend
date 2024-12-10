class AppointmentsController < ApplicationController
  # wrap_parameters :appointments, include: %i[scheduled_days task_end_date]  

  before_action :validate_params, only: [:create, :update, :carer_appointments, :update_progress, :create_recurring, :cancel_appointment]
  before_action :set_appointment, only: [:show, :update, :update_progress, :close_appointment, :destroy, :cancel_appointment]
  before_action :set_recurring_appointment, only: [:recurring, :update_recurring, :destroy_recurring]

  decorate_views({
    decorate_objects: [:carer_appointments, :index_recurring],
    decorate_object: [:update_progress, :close_appointment, :create_recurring, :recurring, :update_recurring, :cancel_appointment]
  })

  def index
    if params[:filter].present?
      @items = scoper
      handle_filter
    else
      @items = scoper.all
    end
  end

  def validate_appointment
    
  end

  def show
  end

  def create_recurring
    @decorator_controller_options = {decorator_method: :recurring_api}
    @item = recurring_scoper.new(build_recurring_params)
    if @item.save
      @item.reload
      render :show, status: :created
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update_recurring
    @decorator_controller_options = {decorator_method: :recurring_api}
    Rails.logger.info("recurring_appointment_params before update :: #{build_recurring_params}")
    if @item.update(build_recurring_params)
      @item.reload
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  def recurring
    @decorator_controller_options = {decorator_method: :recurring_api}
    render :show
  end

  def index_recurring
    @decorator_controller_options = {decorator_method: :recurring_api}
    @items = recurring_scoper.all
    render :index
  end

  def destroy_recurring
    if @item.destroy
      head 204
    else
      render :show, status: :unprocessable_entity
    end
  end

  def create
    @item = scoper.new(appointment_params)
    if @item.save
      @item.reload
      render :show, status: :created
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(appointment_params)
      @item.reload
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    if @item.destroy
      head 204
    else
      render :show, status: :unprocessable_entity
    end
  end

  def cancel_appointment
    if @item.cancel(cancel_info)
      @item.reload
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  def carer_appointments
    @items = current_agent.appointments
    render :index, status: :ok
  end

  def update_progress #currently only for check-in
    agent_appointment = @item.agent_appointments.find_by_agent_id(current_user.id)
    if agent_appointment.update(:status => 'inprogress')
      @item.reload
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  def close_appointment
    if @item.update(direct_close_status)
      @item.reload
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

    def set_recurring_appointment
      @item = recurring_scoper.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      raise CustomErrors::NotFound, 'Invalid Resource ID'
    end

    def build_recurring_params
      recurring_appointment_params.merge({agent_ids: set_agent_ids, scheduled_days: params[:scheduled_days], task_end_date: params[:task_end_date]})
    end

    def set_agent_ids
      params.dig(:appointment, :agent_appointments_attributes).collect do |x|
        x['agent_id']
      end
    end

    def recurring_scoper
      current_account.recurring_tasks.includes([:client])
    end

    def scoper
      current_account.appointments.includes([:client, :agents, :emergency_notes])
    end

    def set_appointment
      @item = scoper.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      raise CustomErrors::NotFound, 'Invalid Resource ID'
    end

    def cancel_info
      params[:appointment][:cancel_note]
    end

    def checkin_params
      params.require(:appointment).permit(map_data: [:lat, :lng])
    end

    def appointment_params
      params.require(:appointment).permit(:client_id, :notes, :start_time, :end_time, services: [], agent_appointments_attributes: [:agent_id])
    end

    def recurring_appointment_params
      params.require(:appointment).permit(:client_id, :notes, :start_time, :end_time, :task_end_date, services: [], scheduled_days: [])
    end

    def progress_update_params #unused
      params.require(:appointment).permit(agent_appointments_attributes: [:id, :agent_id, :status])
    end

    def close_appointment_params
      params.require(:appointment).permit(feedbacks_attributes: [:id, :description, :note_type, :client_id, :agent_id, services: []])
    end

    def direct_close_status
      agent_appt = @item.agent_appointments.find_by_agent_id(current_user.id)
      close_appt_sys_param = {
        agent_appointments_attributes: [
          {
            id: agent_appt.id,
            status: 'completed'
          }
        ]
      }
      close_appointment_params.merge(close_appt_sys_param)
    end

    def validate_params
      @appointment_delegator = AppointmentDelegator.new(params, {context: @_action_name.to_sym})
      unless @appointment_delegator.valid?
        render :show, status: :unprocessable_entity
      end
    end

    def handle_filter
      params[:filter].each do |key, value|
        @items = @items.safe_send(key, value)
      end
    end
end
# https://medium.com/@dakotaleemartinez/rails-appointments-project-4a16eaf1f7ca
