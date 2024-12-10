class HolidayDecorator < ApplicationDecorator
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
      from_time: object.from_time,
      to_time: object.to_time,
      reason: object.reason,
      agent_id: object.agent_id,
      agent_name: object.agent.name,
    }
  end

end
