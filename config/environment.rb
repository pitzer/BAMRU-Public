require 'rubygems'
require 'bundler/setup'
require 'active_record'
require 'active_support/core_ext'
# require 'factory_girl'
require 'time'

BASE_DIR  = File.dirname(File.expand_path(__FILE__)) + "/../"
DATA_DIR  = BASE_DIR + "/data"

INVAL_CSV_FILENAME = "/tmp/inval_csv.csv"
INVAL_REC_FILENAME = "/tmp/inval_rec.csv"

database_file = case ENV['RACK_ENV']
  when "production" then "production.sqlite3"
  when "test"       then "test.sqlite3"
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
# require BASE_DIR + "db/factories"

BORG_ENVIRONMENT_FILE = File.expand_path("~/.borg_environment.yaml")
yaml_env = YAML.load_file(BORG_ENVIRONMENT_FILE)

GCAL_USER = yaml_env[:gcal_user]
GCAL_PASS = yaml_env[:gcal_pass]

