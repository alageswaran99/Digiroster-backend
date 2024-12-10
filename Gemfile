source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', "~> 7.0.6"
# Use postgresql as the database for Active Record
gem 'pg', "~> 1.1"
# Use Puma as the app server
gem 'puma', "6.2.0"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11.5'
gem 'draper', '~> 4.0.1'
gem 'pagy', '~> 6.0.4' # Pagination
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 5.0.6'
gem 'redis-namespace', '~> 1.8.1'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# for performance management of web application in production
gem 'newrelic_rpm'
# to analyze 100% of your newrelic trace data
gem 'newrelic-infinite_tracing'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

#To run background jobs
gem 'delayed_job_active_record'

# For Params validation
gem 'rails_param'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
# for filtering
gem 'toschas-filterable'

gem 'rest-client'
gem 'aws-sdk-s3'
gem 'twilio-ruby'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'bullet'
  gem 'active_record_query_trace'
  gem 'solargraph'
  gem 'prettier'
  gem 'awesome_print'
end

group :test do
  gem 'faker'
  gem 'json_expressions'
  # gem 'minitest-ci'
  # gem 'minitest-reporters'
  gem 'mocha' # to mock objects, mainly used while writing unit test
  gem 'simplecov' # to track code coverage
  gem 'webmock' # to mock web request i.e other eternal services
  # gem 'simplecov-cobertura'
  # gem 'simplecov-rcov'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


#For Authentication
gem 'devise', '4.8.1'
gem 'devise-jwt'
gem 'warden-jwt_auth', git: 'https://github.com/Ramkumar05/warden-jwt_auth.git', branch: '12-aug-2023'

# local clone - start
# gem 'warden-jwt_auth', :path => "/Users/Ramkumar.Rajendran/Documents/GitHub/warden-jwt_auth"
# gem 'devise-jwt', :path => "/Users/Ramkumar.Rajendran/Documents/GitHub/devise-jwt"
# local clone - end

# removed
# gem 'warden-jwt_auth', git: 'https://github.com/Ramkumar05/warden-jwt_auth.git', branch: 'multi_tenant'

# Local imported gems - Start
# gem 'devise', :path => "#{File.expand_path(__FILE__)}/../vendor/gems/devise-4.8.1"
# gem 'devise-jwt', :path => "#{File.expand_path(__FILE__)}/../vendor/gems/devise-jwt"
# gem 'warden-jwt_auth', :path => "#{File.expand_path(__FILE__)}/../vendor/gems/warden-jwt_auth"

# gem 'delayed_job_active_record', :path => "#{File.expand_path(__FILE__)}/../vendor/gems/delayed_job_active_record-4.1.5"
# gem 'delayed_job', :path => "#{File.expand_path(__FILE__)}/../vendor/gems/delayed_job-4.1.9"
# For Privileges management
gem "freshcare_authority", :path => "#{File.expand_path(__FILE__)}/../vendor/gems/freshcare_authority-0.1"
# Local imported gems - End
