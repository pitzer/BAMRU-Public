require 'rubygems'
require 'bundler/setup'
require 'active_record'
require 'active_support/core_ext'
require 'factory_girl'
require 'schedule'
require 'time'

BASE_DIR  = File.dirname(File.expand_path(__FILE__)) + "/../"
DATA_DIR  = BASE_DIR + "/data"

INVAL_CSV_FILENAME = "/tmp/inval_csv.csv"
INVAL_REC_FILENAME = "/tmp/inval_rec.csv"

database_file = case ENV['RACK_ENV']
  when "production" : "production.sqlite3"
  when "test"       : "test.sqlite3"
  else "database.sqlite3"
end

# initialize the database
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  BASE_DIR + "db/#{database_file}"
)

# load all lib
Dir[BASE_DIR + "lib/*.rb"].each {|f| load f}

# load factory definitions
require BASE_DIR + "db/factories"
