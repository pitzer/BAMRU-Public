base_dir = File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
require File.expand_path('config/environment',  base_dir)
require File.expand_path('lib/env_settings',    base_dir)
require File.expand_path('lib/gcal_sync',       base_dir)

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

def break() puts '*' * 60; end

Dir.glob(base_dir + "/lib/tasks/*.rake") {|x| load x}

task :default => :msg

task :msg do
  puts "Use 'rake -T' to see rake options"
end

def end_task(msg)
  puts msg
  exit
end

desc "Run the development server"
task :run_server do
  system "xterm_title '<thin> #{File.basename(`pwd`).chomp}@#{ENV['SYSNAME']}:9393'"
  system "touch tmp/restart.txt"
  system "shotgun config.ru -s thin -o 0.0.0.0"
end
task :run => :run_server

desc "Run console with live environment"
task :console do
  require 'irb'
  require 'irb/completion'
  require File.dirname(File.expand_path(__FILE__)) + '/config/environment'
  ARGV.clear
  IRB.start
end
task :con => :console

desc "Send an alert message"
task :alert_mail do
  msg = ENV['ALERT_MSG']
  msg.nil? ? AlertMail.send : AlertMail.send(msg)
end

namespace :db do

  task :environment do
    require File.dirname(File.expand_path(__FILE__)) + '/config/environment'
  end

  desc "Remove existing databases"
  task :drop do
    Dir["*/*.sqlite3"].each {|f| puts "Dropping #{f}"; File.delete(f)}
  end

  desc "Run database migration"
  task :migrate => :environment do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  desc "Remove all data from database"
  task :reset => :environment do
    puts "Removing all database records"
    Event.delete_all_with_validation
  end

  desc "Load seed data"
  task :seed => [:environment, :reset] do
    puts "Loading Seed Data"
    require 'db/seed'
  end

  desc "Load CSV data"
  task :csv => :environment do
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

