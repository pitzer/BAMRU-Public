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
    puts "Rcov generated - view at 'coverage/index.html"
  end

end

task :rdoc_cleanup do
  system "rm -rf doc"
end

desc "Generate Rdoc"
task :rdoc => :rdoc_cleanup do
  system "rdoc models/*.rb README.rdoc -N --main README.rdoc"
  puts "Rdoc generated - view at 'doc/index.html'"
end

desc "Remove all Rcov and Rdoc data"
task :cleanup => ['spec:rcov_cleanup', :rdoc_cleanup] do
  puts "Done"
end
task :clean => :cleanup