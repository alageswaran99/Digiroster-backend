class FeedbackDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def api_decorate
    {
      id: object.id,
      agent_id: object.agent_id,
      client_id: object.client_id,
      agent: build_agent_data,
      client: build_client_data,
      appointment_id: object.appointment_id,
      services: object.services,
      description: object.description,
      note_type: object.note_type,
      created_at: object.created_at,
      updated_at: object.updated_at
    }
  end

  def build_agent_data
    {
      id: object.agent.id,
      name: object.agent.full_name_with_title
    }
  end

  def build_client_data
    {
      id: object.client.id,
      name: object.client.full_name_with_title
    }
  end

end
