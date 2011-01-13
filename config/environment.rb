require 'rubygems'
require 'active_record'
require 'factory_girl'

base_dir = File.dirname(File.expand_path(__FILE__))

# initialize the database
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  base_dir + '/../data/database.sqlite3'
#  :database =>  '/tmp/database.sqlite3'
)

# load all models
Dir[base_dir + "/../models/*.rb"].each {|f| load f}

# load factory definitions
require base_dir + "/../db/factories"

