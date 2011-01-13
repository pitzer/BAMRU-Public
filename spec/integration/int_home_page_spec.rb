require 'integration_helper'

describe "Home Page" do

  include Capybara

  before(:each) do
    Capybara.app = VisiTeams::Application
    Capybara.javascript_driver = :envjs
  end

  context "basic rendering tests" do
    before(:each) { visit '/' }
    specify do
      page.body.should include("VisiTeams")
    end
  end

end
