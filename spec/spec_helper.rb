ENV["RACK_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec'

RSpec.configure do |config|
  config.mock_with :rspec
  config.before(:each) { Action.delete_all_with_validation }
end
