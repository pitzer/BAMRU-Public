require 'integration_helper'

describe "Home Page" do

  include Capybara

  before(:each) do
    Capybara.app = BamruApp
  end

  context "basic rendering tests" do
    before(:each) { visit '/calendar.test' }
    specify do
      page.body.should include("BAMRU")
    end
  end

end
