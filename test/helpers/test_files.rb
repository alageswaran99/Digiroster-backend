Dir["#{Rails.root}/test/helpers/*.rb"].each { |file| require file }
Dir["#{Rails.root}/test/helpers/**/*.rb"].each { |file| require file }