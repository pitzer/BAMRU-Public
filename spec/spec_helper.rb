ENV["RACK_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require File.expand_path("../../app", __FILE__)
require File.expand_path("../factories", __FILE__)
require 'time'
require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'launchy'

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Capybara::DSL
  config.before(:each) { Event.delete_all_with_validation }
end

# ----- This is for testing the CsvLoader -----

FIELDS = %w(kind title location description start finish lat lon leaders)
HEADER = FIELDS.map {|f| %Q("#{f}")}.join(',')

NUM_INPUT     = 5
NUM_INVAL_CSV = 1
NUM_INVAL_REC = 1
NUM_VALID_CSV = 4
NUM_VALID_REC = 3

def csv_record(direction = "none")
  kind  = %w(meeting training operation other).to_a.sample
  kind  = "invalid" if direction == "invalid"
  title = "Test Record " + (1..9999).to_a.sample.to_s
  title = %q(Malformed " Record) if direction == "malformed"
  year  = (2001 .. 2012).to_a.sample
  month = ("01" .. "12").to_a.sample
  day   = ("01" .. "30").to_a.sample
  start = "#{year}-#{month}-#{day}"
  %Q("#{kind}","#{title}","","","#{start}","","","","")
end

def valid_test_data
  output = HEADER + "\n"
  NUM_INPUT.times { output << csv_record + "\n" }
  output
end

def inval_test_data
  output = HEADER + "\n"
  (NUM_INPUT-2).times { output << csv_record + "\n" }
  output << csv_record("invalid") + "\n"
  output << csv_record("malformed") + "\n"
  output
end

def should_be_hidden(text, selector)
  hidden_script = "$('#{selector}:contains(#{text})').is(':hidden');"
  dom_script    = "$('#{selector}:contains(#{text})').length == 0;"
  is_hidden     = page.evaluate_script(hidden_script)
  is_not_in_dom = page.evaluate_script(dom_script)
  (is_hidden || is_not_in_dom).should be_true
end

def should_not_be_hidden(text, selector)
  ! should_be_hidden(text, selector)
end

