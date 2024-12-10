module DecoratorConcern
  extend ActiveSupport::Concern

  ACTION_MAPPING = {
    decorate_object: [:create, :update, :show, :destroy],
    decorate_objects: [:index]
  }.freeze
  DECORATOR_METHOD_MAPPING = ACTION_MAPPING.each_with_object({}) { |(k, v), inverse| v.each { |e| inverse[e] = k } }

  DECORATOR_NAME_REGEX = /Devise::|Users::|/

  module ClassMethods
    attr_reader :decorator_method_mapping

    def decorate_views(options = {})
      custom_options = ACTION_MAPPING.merge(options)
      custom_method_mapping = custom_options.each_with_object({}) { |(k, v), inverse| v.each { |e| inverse[e] = k } }
      @decorator_method_mapping = DECORATOR_METHOD_MAPPING.merge(custom_method_mapping)
    end

    def decorator_name
      @name ||= "#{name.gsub('Controller', '').singularize}Decorator".constantize
    end

    def delegator_instance_name
      @delegator_instance_name ||= "@#{name.gsub('Controller', '').gsub(DECORATOR_NAME_REGEX, '').singularize.underscore}_delegator".downcase
    end
  end

  def list_decorator_methods
    current_class = self.class
    super_class = current_class.superclass
    (current_class.decorator_method_mapping ||
          super_class.decorator_method_mapping)
  end

  def render(*options, &block)
    @items = pagy_custom(@items) if @items #for pagination
    set_errors(*options) unless @skip_default_error #set @skip_default_error = true in your controller to skip this
    safe_send(decorator_method) if @errors.blank? && decorator_method && (@item || @items)
    super(*options, &block)
  end

  def set_errors(*response_options)
    @errors ||= {}
    @errors.merge!(@item.errors) if @item && @item.errors
    @errors.merge!(instance_variable_get(self.class.delegator_instance_name).errors) if instance_variable_get(self.class.delegator_instance_name) 
                                                                  # yet to introduce error decorator or 
                                                                  # current resource delegator to handle error
    @item = @items = nil unless @errors.blank? # if create failed these variable will have partially build object which is not persisted in db
  end

  def decorate_objects
    decorator, options = decorator_options(@decorator_controller_options)
    @items = @items.map { |item| decorator.new(item, options).api_decorate }
  end

  def decorate_object
    result = decorator_options(@decorator_controller_options)
    if result
      decorator, options = result
      @item = decorator.new(@item, options).api_decorate
    end
  end

  def decorator_options(options = {})
    [self.class.decorator_name, options]
  end

  def decorator_method
    return nil if list_decorator_methods.nil? || list_decorator_methods.blank?

    @decorator_controller_options ||= {}
    @decorator_method ||= list_decorator_methods[action_name.to_sym]
  end

  # def errors_empty?
  #   !(@errors || @error)
  # end
end
