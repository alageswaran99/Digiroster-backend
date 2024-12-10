include Pagy::Backend
module PagyCustomHelper
  def raise_not_found!
    raise ActionController::RoutingError, 'Route Not Found'
  end

  def pagy_custom(query)
    return [] if query.nil?
    # binding.pry
    # pagy_countless(query, { page: params[:page], items: params[:items] }).last
    query
  rescue Pagy::OverflowError               # if no items present in that page, throws exception
    []
  end

  #unused as of now
  def set_pagy_params
    params[:page]   ||= 1
    params[:items]  ||= 500
    param! :page, Integer
    param! :items, Integer
  end
end