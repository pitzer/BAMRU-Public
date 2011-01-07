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

def break() puts '*' * 60; end

task :default => :msg

task :msg do
  puts "Use 'rake -T' to see rake options."
end

desc "Run the development server."
task :run_server do
  system "shotgun config.ru -o 0.0.0.0"
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

namespace :db do

  task :environment do
    require 'config/environment'
  end

  desc "Run database migration"
  task :migrate => :environment do
    system "rm -f db/*.sqlite3"
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  desc "Remove all data from database."
  task :reset => :environment do
    puts "Removing all database records"
    Event.all.each {|e| e.destroy}
  end

  desc "Load seed data"
  task :seed => [:environment, :reset] do
    puts "Loading Seed Data"
    require 'db/seed'
  end

end

