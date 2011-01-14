require 'rubygems'
require 'active_record'
require 'factory_girl'

base_dir = File.dirname(File.expand_path(__FILE__))

database_file = case ENV['RACK_ENV']
  when "production" : "production.sqlite3"
  when "test"       : "test.sqlite3"
  else "database.sqlite3"
end

# initialize the database
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  base_dir + "/../db/#{database_file}"
)

# load all models
Dir[base_dir + "/../models/*.rb"].each {|f| load f}

# load factory definitions
require base_dir + "/../db/factories"

