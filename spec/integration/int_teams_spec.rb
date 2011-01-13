require 'integration_helper'

describe "Teams Page" do

  include Capybara

  before(:each) do
    Capybara.app = VisiTeams::Application
    Capybara.javascript_driver = :envjs
    p = '123456'
    @u = User.create(:email => "x@x.com", :password => p, :password_confirmation => p)
    @t = @u.teams.create(:name => "ttt")
    @w = @t.workspaces.create(:name => "hello", :url => "hello")
  end

  context "after successful login" do
    before(:each) do
      login_as @u
      visit '/teams'
    end

    it "should render the team page" do
      page.body.should include("x@x.com")
      page.body.should include("VisiTeams")
      page.body.should include("ttt")
    end

    it "should be able to add a team" do
      click_link 'Create New Team'
      fill_in "team_name",        :with => "ddd"
      fill_in "team_description", :with => "hello ddd"
      click_button "Create Team"
      page.body.should include "was successfully created."   # flash message
      page.body.should include "ddd"
      Team.count.should == 2
    end

    it "should be able to delete a team" do
      Team.count.should == 1
      click_button 'Delete'
      page.body.should include "was destroyed" # flash message
      Team.count.should == 0
    end

    it "should be able to edit a team" do
      visit '/teams'
      click_button "Edit"
      fill_in "team_name", :with => "bbb"
      click_button "Update Team"
    end

  end
end
