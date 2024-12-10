class AgentDecorator < ApplicationDecorator
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
      address: object.address,
      mobile: object.mobile,
      roles: add_roles,
      postcode: object.postcode,
      dob: object.dob,
      region_ids: object.region_ids,
      gender_readable: object.gender_as_readable,
      role_ids: object.role_ids,
      first_name: object.first_name,
      last_name: object.last_name,
      gender: object.gender,
      title: object.title,
      group_id: object.group_id,
      working_hours: object.try(:working_hours),
      file_detail: build_file_info,
      deleted: object.deleted
    }
  end

  def build_file_info
    return [] unless object.general_file.attached?

    [
      {
        name: 'general_file',
        user_given_name: object.general_file.attachable_filename,
        url: object.general_file.url
      }
    ]
  end

  def add_roles
    object.roles.map { |e| e.api_format }
  end
end
