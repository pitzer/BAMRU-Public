require "integration_helper"

describe "App Page" do

  include Capybara

  before(:each) do
    Capybara.app = VisiTeams::Application
    Capybara.javascript_driver = :envjs
    @u = Factory(:normal_user)
    @p = @u.plugins.create(:name => "ppp", :klass => "new")
    @t = @u.teams.create(:name => "ttt")
    @w = @t.workspaces.create(:name => "www", :users => [@u])
    @a = @w.apps.create(:name => "aaa", :plugin => @p)
  end

  context "upon successful login" do
    before(:each) do
      login_as(@u)
      visit '/workspaces/1'
    end

    it "should render the apps page" do
      page.body.should include("VisiTeams")
      page.body.should include("aaa")
      App.count.should == 1
    end

    it "should be able to add a app" do
      App.count.should == 1
      click_link "Create New App"
      fill_in "app_name",        :with => "zzz"
      fill_in "app_description", :with => "hello zzz"
      click_button "Create App"
      App.count.should == 2
    end

    it "should be able to delete a app" do
      App.count.should == 1
      click_button "Delete"
      App.count.should == 0
    end

    it "should be able to edit a app" do
      click_button "Edit"
      fill_in "app_name",      :with => "bbb"
      click_button "Update App"
      page.body.should include "was successfully updated" # flash message
      page.body.should include "bbb"
    end

  end

end
