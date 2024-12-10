class RoleDecorator < ApplicationDecorator
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
      name: object.name,
      description: object.description,
      default_role: object.custom_default_role,
      privileges: object.privilege_list
    }
  end
end
