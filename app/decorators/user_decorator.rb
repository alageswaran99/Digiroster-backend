class UserDecorator < ApplicationDecorator
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
      name: object.full_name_with_title,
      email: object.email,
      role_ids: object.role_ids,
      roles: add_roles,
      first_name: object.first_name,
      last_name: object.last_name,
      gender: object.gender,
      title: object.title,
      gender_readable: object.gender_as_readable
    }
  end

  def add_roles
    object.roles.map { |e| e.api_format }
  end
end
