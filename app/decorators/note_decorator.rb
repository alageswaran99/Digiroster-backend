class NoteDecorator < ApplicationDecorator
  # delegate_all

  def api_decorate
    {
      id: object.id,
      data: object.data,
      agent_id: object.agent_id,
      client_id: object.client_id,
      appointment: object.appointment.try(:mini_api_format),
      created_at: object.created_at,
      updated_at: object.updated_at
    }
  end

end
