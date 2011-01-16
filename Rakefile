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
  system "touch tmp/restart.txt"
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
task :con => :console

namespace :db do

  task :environment do
    require 'config/environment'
  end

  desc "Run database migration"
  task :drop do
    Dir["*/*.sqlite3"].each {|f| puts "Dropping #{f}"; File.delete(f)}
  end

  task :migrate => :environment do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  desc "Remove all data from database."
  task :reset => :environment do
    puts "Removing all database records"
    Event.delete_all_with_validation
  end

  desc "Load seed data"
  task :seed => [:environment, :reset] do
    puts "Loading Seed Data"
    require 'db/seed'
  end

end
  namespace :spec do
    desc "Run all specs in spec/models"
    task :models do
      cmd = "rspec -O spec/spec.opts spec/models/*_spec.rb"
      puts "Running MODEL Specs"
      puts cmd
      system cmd
    end

    desc "Run all specs in specs/integration"
    task :integration do
      cmd = "rspec -O spec/spec.opts spec/integration/*_spec.rb"
      puts "Running INTEGRATION Specs"
      puts cmd
      system cmd
    end

    # desc "Run all specs in specs/helpers"
    task :helpers do
      cmd = "rspec -O spec/spec.opts spec/helper/**/*_spec.rb"
      puts "Running HELPER Specs"
      puts cmd
      system cmd
    end

    desc "Run all specs"
    task :all => [:models, :integration]

end

