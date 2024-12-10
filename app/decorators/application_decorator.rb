class ApplicationDecorator < Draper::Decorator
  attr_accessor :options
  def initialize(current_object, options = {})
    @options = options
    super(current_object)
  end

  def merge_hashes(result_hash, *args)
    result_hash.merge(*args)
  end
  
  # Define methods for all decorated objects.
  # Helpers are accessed through `helpers` (aka `h`). For example:
  #
  #   def percent_amount
  #     h.number_to_percentage object.amount, precision: 2
  #   end
end
