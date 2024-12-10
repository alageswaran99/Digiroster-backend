class GroupDecorator < ApplicationDecorator
  delegate_all

  def api_decorate
    {
      id: object.id,
      name: object.name,
      description: object.description,
      group_type: object.group_type
    }
  end

end
