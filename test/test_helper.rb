ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'
require 'rails/test_help'
require_relative 'helpers/test_files.rb'
require 'faker'
require 'simplecov'
require 'webmock/minitest'
require 'json_expressions/minitest'
require 'rake'
require 'pry'

Faker::Config.locale = 'en-IND'

COVERAGE_SKIP_FILES = []

SimpleCov.start 'rails' do #unless ENV['NO_COVERAGE']
  COVERAGE_SKIP_FILES.each do |_file|
    add_filter _file
  end
end

Freshcare::Application.load_tasks

p "Cleaning tables...."
Rake::Task['test_env:clean_tables'].invoke
p "Table cleanup done...."

p "Run pending migrations...."
Rake::Task['test_env:setup_db'].invoke
p "Migration done...."

class ActiveSupport::TestCase
  self.use_transactional_tests = false
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  self.use_transactional_tests = false

  setup do
  end
end

class ActionController::TestCase
  self.use_transactional_tests = false
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  setup do
    # all set ups goes here
  end

  # Add more helper methods to be used by all tests here...
  # def match_json(json)
  #   if [400, 409].include?(response.status) && json.is_a?(Array)
  #     json = {
  #       description: "dummy",
  #       errors: json
  #     }
  #   end
  #   assert_json_match(json, response.body)
  # end
end
