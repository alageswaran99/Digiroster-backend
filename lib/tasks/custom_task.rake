namespace :test_env do
  desc "Setting up Test database"

  task :setup_db => :environment do
    raise "Its not test environment!!!" unless Rails.env.test?
    Rake::Task["db:schema:load"].invoke
  end

  task :clean_tables => :environment do
    puts "Truncate all tables"
    raise "Its not test environment!!!" unless Rails.env.test?
    
    conn = ActiveRecord::Base.connection
    raw_sql = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;"
    tables = conn.execute(raw_sql).map { |r| r["table_name"] }
    tables.delete "schema_migrations"
    tables.delete "ar_internal_metadata"
    tables.each { |t|
      conn.execute("TRUNCATE #{t} CASCADE") 
    }
  end
end