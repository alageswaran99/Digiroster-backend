module Behaveable
  module ResourceFinder
    # Get the behaveable object.
    #
    # ==== Returns
    # * <tt>ActiveRecord::Model</tt> - Behaveable instance object.

    OBJ_MAPPING = {
      # 'CommentsController' => ['visit', 'deal', 'proposal', 'action_item']
    }

    def behaveable
      klass, param = behaveable_class
      klass.find(params[param.to_sym]) if klass
    rescue => exception
      raise CustomErrors::NotFound, exception.message
    end
    private
    
    # Lookup behaveable class.
    #
    # ==== Returns
    # * <tt>Response</tt> - Behaveable class or nil if not found.
    def behaveable_class
      params.each do |name|
        if name.first =~ /(.+)_id$/
          if check_mapping($1)
            return [$1.classify.constantize, name.first]
          end
        end
      end
      nil
    end

    def check_mapping(model_name)
      return true if OBJ_MAPPING[self.class.name].nil?
      
      OBJ_MAPPING[self.class.name].include?(model_name)
    end
  end
end

# https://medium.com/@loickartono/rails-nested-routes-polymorphic-associations-and-controllers-8ade7249fa49