require 'rubygems'
require 'time'
require 'bundler/setup'
require 'active_record'
require 'active_support/core_ext'
require 'debugger' unless ENV['RACK_ENV'] == 'production'

BASE_DIR  = File.expand_path('../', File.dirname(__FILE__))
DATA_DIR  = BASE_DIR + "/data"

INVAL_CSV_FILENAME = "/tmp/inval_csv.csv"
INVAL_REC_FILENAME = "/tmp/inval_rec.csv"

DATABASE_FILE = case ENV['RACK_ENV']
  when "production" then "production.sqlite3"
  when "test"       then "test.sqlite3"
  else "database.sqlite3"
end

DATABASE_SPEC = BASE_DIR + "/db/#{DATABASE_FILE}"

# initialize the database
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => DATABASE_SPEC
)

# load all lib
Dir[BASE_DIR + "/lib/*.rb"].each {|f| load f}

