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
  require File.expand_path('../', __FILE__) + '/config/environment'
  ARGV.clear
  IRB.start
end
task :con => :console

desc "Send an alert message"
task :alert_mail do
  msg = ENV['ALERT_MSG']
  msg.nil? ? AlertMail.send : AlertMail.send(msg)
end
