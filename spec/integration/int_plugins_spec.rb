require "integration_helper"

describe "Working with Plugins" do

  include Capybara

  before(:each) do
    Capybara.app = VisiTeams::Application
    Capybara.javascript_driver = :envjs
    @d = Factory(:developer_user)
    @n = Factory(:normal_user)
    @t = @n.teams.create(:name => "ttt")
    @p = @d.plugins.create(:name => "ppp")
    @w = @t.workspaces.create(:name => "www", :users => [@n])
    @a = @w.apps.create(:name => "aaa")
    login_as(nil)
  end

  context "- when not logged in" do
    before(:each) do
      visit '/users/sign_out'
    end

    context "plugins page" do
      before(:each) { visit '/plugins' }
      it "should show an error message" do
        page.body.should include("Access Denied")
      end
    end
  end

  context "- when logged in as a normal user" do
    before(:each) { login_as(@n) }

    context ": plugins page" do
      before(:each) { visit '/plugins' }
      it "should show an error message" do
        page.body.should include("Access Denied")
      end
    end

    context "settings page" do
      before(:each) { visit '/'; click_link 'Settings' }
      it "should not show the plugins link" do
        page.body.should_not include("My Plugins")
      end
    end

  end

  context "- when logged in as a developer user" do
    before(:each) { login_as(@d) }

    context ": settings page" do
      before(:each) { visit '/'; click_link 'Settings' }
      it "should show the plugins link" do
        page.body.should include("My Plugins")
      end
    end

    context "- plugins page" do
      before(:each) { visit '/plugins' }

      it "should render the plugins page" do
        page.body.should include("VisiTeams")
        page.body.should include("ppp")
        Plugin.count.should == 1
      end

      it "should be able to add a plugin" do
        Plugin.count.should == 1
        click_link("Create New Plugin")
        fill_in "plugin_name", :with => "zzz"
        click_button "Create Plugin"
        Plugin.count.should == 2
      end

      it "should be able to delete a plugin" do
        Plugin.count.should == 1
        click_button "Delete"
        Plugin.count.should == 0
      end

      it "should be able to edit a plugin" do
        click_button "Edit"
        fill_in "plugin_name", :with => "bbb"
        click_button "Update Plugin"
        page.body.should include "was successfully updated" # flash message
        page.body.should include "bbb"
      end
    end

  end

end
