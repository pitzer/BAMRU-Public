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
    puts "Generating Spec Documentation"
    puts cmd
    system cmd
  end
end

desc "Generate Rdoc"
task :rdoc => 'rdoc:clear' do
  system "rdoc models/*.rb README.rdoc --main README.rdoc"
  puts "Rdoc generated - view at 'doc/index.html'"
end

namespace :rdoc do
  desc "Clear Rdoc"
  task :clear do
    system "rm -rf doc"
    puts "Rdoc removed"
  end
end
