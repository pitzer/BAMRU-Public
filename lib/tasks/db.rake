namespace :db do

  desc "Remove existing databases"
  task :drop do
    Dir["*/*.sqlite3"].each {|f| puts "Dropping #{f}"; File.delete(f)}
  end

  desc "Run database migration"
  task :migrate do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  desc "Roll back one migration"
  task :rollback do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.rollback("db/migrate", 1)
  end

  desc "Remove all data from database"
  task :reset do
    puts "Removing all database records"
    Event.delete_all_with_validation
  end

  desc "Load seed data"
  task :seed => :reset do
    puts "Loading Seed Data"
    require 'db/seed'
  end

  desc "Load CSV data"
  task :csv do
    file = ENV['CSV'] || "data/csv/working_copy.csv"
    puts "Loading CSV Data"
    puts " > using data from '#{file}'"
    puts " > run with 'CSV=<filename>' to use another file"
    csv_load = CsvLoader.new(file)
    puts "Processed #{csv_load.num_input} records."
    puts "Loaded #{csv_load.num_successful} records successfully."
    ms = csv_load.num_malformed == 0 ? "" : "(view at #{MALFORMED_FILENAME})"
    puts "Found #{csv_load.num_malformed} malformed records. #{ms}"
    is = csv_load.num_invalid == 0 ? "" : "(view at #{INVALID_FILENAME})"
    puts "Found #{csv_load.num_invalid} invalid records. #{is}"
  end

  desc "Show database statistics"
  task :stats => :environment do
    mc, tc = Event.meetings.count, Event.trainings.count
    ec, nc = Event.events.count, Event.non_county.count
    puts "There are a total of #{Event.count} records in the database."
    puts "(#{mc} meetings, #{tc} trainings, #{ec} events, #{nc} non-county)"
  end

end
