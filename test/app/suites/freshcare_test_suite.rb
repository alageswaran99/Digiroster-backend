# require 'pry'
# functional
functional_tests = Dir.glob('test/**/*_test.rb')

# unit
unit_tests = Dir.glob('test/unit/**/*_test.rb')

# Files to skip
skip_files = [
  'test/controllers/accounts_controller.rb',
  'test/controllers/users_controller_test.rb'
]
all_tests = (unit_tests | functional_tests) - skip_files
puts 'Freshcare Test suite - Tests to run'
puts '*' * 100

all_tests.each { |file| puts file }
all_tests.map do |test|
  p "test #{"*"*50} #{test}"
  require_relative "../../../#{test}"
end
