# class << ActiveRecord::Base
#   def concerned_with(*concerns)
#     # binding.pry
#     concerns.reverse.each do |concern|
#       require_dependency "#{name.underscore}/#{concern}"
#     end
#   end
# end