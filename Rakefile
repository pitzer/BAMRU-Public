require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'rspec/core/rake_task'
require 'lib/shared/tasks/rake_tasks'

def break() puts '*' * 60; end

task :default => :msg

task :msg do
  puts "Use 'rake -T' to see rake options"
end

desc "Import CSV data from Peer URL"
task :data_import do
  require 'config/environment'
  sitep = Settings.new
  abort "Only works with Backup Sites" if sitep.primary?
  abort "Peer Site is undefined" if sitep.peer_url_undefined?
  url = sitep.peer_csv
  uri = URI.parse(url)
  puts "Reading CSV from #{url}..."
  csv_text = Net::HTTP.get_response(uri.host, uri.path).body
  Event.delete_all if CsvLoader.load_ready?(csv_text)
  puts "Loading CSV data..."
  CsvLoader.new(csv_text)
  puts "Saving CSV history..."
  CsvHistory.save
  puts "Done."
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
  require 'config/environment'
  ARGV.clear
  IRB.start
end
task :con => :console

desc "Sync Calendar Data with Google Calendar"
task :gcal_sync do
  require 'config/environment'
  GcalSync.sync
end

desc "Set Primary Role"
task :set_primary_role do
  require 'config/environment'
  config = Settings.new
  config.site_role = "Primary"
  config.save
end

desc "Set Backup Role"
task :set_backup_role do
  require 'config/environment'
  config = Settings.new
  config.site_role = "Backup"
  config.save
end

desc "Set Peer URL"
task :set_peer do
  abort "Need Peer URL (rake set_peer PEER_URL=<url>" unless ENV['PEER_URL']
  require 'config/environment'
  config = Settings.new
  config.peer_url = ENV['PEER_URL']
  config.save
end

namespace :db do

  task :environment do
    require 'config/environment'
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

desc "Run all specs"
task :spec do
  cmd = "rspec -O spec/spec.opts spec/**/*_spec.rb"
  puts "Running All Specs"
  puts cmd
  system cmd
end

namespace :spec do
  desc "Show spec documentation"
  task :doc do
    cmd = "rspec -O spec/spec.opts --format documentation spec/**/*_spec.rb"
    puts "Generating Spec documentation"
    puts cmd
    system cmd
  end

  desc "Generate HTML documentation"
  task :html do
    outfile = '/tmp/spec.html'
    cmd = "rspec -O spec/spec.opts --format html spec/**/*_spec.rb > #{outfile}"
    puts "Generating HTML documentation"
    puts cmd
    system cmd
    puts "HTML documentation written to #{outfile}"
  end

  task :rcov_cleanup do
    system "rm -rf coverage"
  end

  desc ""
  RSpec::Core::RakeTask.new(:run_rcov) do |t|
    t.rcov = true
    t.rcov_opts = %q[--exclude "/home" --exclude "spec"]
    t.verbose = true
  end

  desc "Generate coverage report"
  task :rcov => [:rcov_cleanup, :run_rcov] do
    puts "Rcov generated - view at 'coverage/index.html'"
  end

end

task :rdoc_cleanup do
  system "rm -rf doc"
end

desc "Generate Rdoc"
task :rdoc => :rdoc_cleanup do
  system "rdoc lib/*.rb README.rdoc -N --main README.rdoc"
  puts "Rdoc generated - view at 'doc/index.html'"
end

desc "Remove all Rcov and Rdoc data"
task :cleanup => ['spec:rcov_cleanup', :rdoc_cleanup] do
  puts "Done"
end
task :clean => :cleanup
