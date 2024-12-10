class RegionDecorator < ApplicationDecorator
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
      email: object.email,
      address: object.address,
      phone: object.phone,
    }
  end

end
