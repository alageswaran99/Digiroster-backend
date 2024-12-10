class AppointmentDecorator < ApplicationDecorator
  delegate_all

  def api_decorate
    options[:decorator_method] ? safe_send("#{options[:decorator_method]}_decorate") : default_decorate
  end

  def mini_api_decorate
    {
      id: object.id,
      client_id: object.client_id,
      agent_ids: object.agent_ids,
      appointment_start_time: object.start_time,
      appointment_end_time: object.end_time,
      services: object.services,
      notes: object.notes,
      status: build_status_for_agents, #danger can cause infinite loop
      recurring: object.recurring,
      appointment_status: object.appt_status,
      cancel_note: object.cancel_note,
      emergency_note_ids: object.emergency_note_ids
    }
  end

  def default_decorate
    {
      id: object.id,
      client_id: object.client_id,
      agent_ids: object.agent_ids,
      client: object.client.api_format,
      agents: object.agents.map(&:api_format),
      appointment_start_time: object.start_time,
      appointment_end_time: object.end_time,
      services: object.services,
      notes: object.notes,
      feedbacks: object.feedbacks.map(&:api_format),
      status: build_status_for_agents,
      recurring: object.recurring,
      appointment_status: object.appt_status,
      cancel_note: object.cancel_note,
      emergency_notes: object.emergency_notes.map(&:api_format)
    }
  end

  def recurring_api_decorate
    {
      id: object.id,
      client_id: object.client_id,
      agent_ids: object.agent_ids,
      client: object.client.api_format,
      agents: object.agents.map(&:api_format),
      appointment_start_time: object.formatted_start_time,
      appointment_end_time: object.formatted_end_time,
      services: object.services,
      notes: object.notes,
      task_end_date: object.formatted_task_end_date,
      scheduled_days: object.scheduled_days
    }
  end

  def build_status_for_agents
    object.agent_appointments.map do | agent_appointment |
      {
        id: agent_appointment.id,
        agent_id: agent_appointment.agent_id,
        status: agent_appointment.status,
        checkin_at: agent_appointment.checkin_at,
        checkout_at: agent_appointment.checkout_at
      }
    end
  end
end
