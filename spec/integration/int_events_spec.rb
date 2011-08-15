require 'spec_helper'
require 'capybara-webkit'
require 'capybara/rspec'

describe "Events Page" do

  include Capybara::DSL

  before(:each) do
    Capybara.app = BamruApp
    Capybara.javascript_driver = :webkit
  end

  context "basic page rendering" do
    before(:each) { ENV['ADMIN_LOGGED_IN'] = 'true' }
    it 'renders /admin_events' do
      visit '/admin_events'
      page.should_not be_nil
    end
    it 'displays event checkboxes' do
      visit '/admin_events'
      page.should have_content("meetings")
      page.should have_content("trainings")
      page.should have_content("operations")
      page.should have_content("other")
    end
    it 'displays event headers' do
      visit '/admin_events'
      page.should have_content("Meetings (")
      page.should have_content("Trainings (")
      page.should have_content("Operations (")
      page.should have_content("Other (")
    end

  end

  context "javascript testing" do

    it 'hides meetings', :js => true do
      visit '/admin_events'
      uncheck('meetings_check')
      uncheck('trainings_check')
      should_be_hidden("Meetings", '#meetings')
      should_be_hidden("Trainings", '#trainings')
      page.should have_content("Operations (")
      page.should have_content("Other (")
    end

  end

end
