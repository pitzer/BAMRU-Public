require "integration_helper"

describe "Workspace Page" do

  include Capybara

  before(:each) do
    Capybara.app = VisiTeams::Application
    Capybara.javascript_driver = :envjs
    @u = Factory(:normal_user, :email => "x@x.com")
    @t = @u.teams.create(:name => "ttt")
    @w = @t.workspaces.create(:name => "www", :users => [@u])
#    @a = @w.apps.create(:name => "aaa")
  end

  context "upon successful login" do
    before(:each) do
      login_as(@u)
      visit '/teams/1'
    end

    it "should render the workspace page" do
      page.body.should include("VisiTeams")
      page.body.should include("www")
      Workspace.count.should == 1
    end

    it "should be able to add a workspace" do
      Workspace.count.should == 1
      click_link("Create New Workspace")
      fill_in "workspace_name",        :with => "zzz"
      fill_in "workspace_description", :with => "hello zzz"
      click_button "Create Workspace"
      Workspace.count.should == 2
    end

    it "should be able to delete a workspace" do
      Workspace.count.should == 1
      click_button "Delete"
      Workspace.count.should == 0
    end

    it "should be able to edit a workspace" do
      click_button "Edit"
      fill_in "workspace_name",      :with => "bbb"
      click_button "Update Workspace"
      page.body.should include "was successfully updated" # flash message
      page.body.should include "bbb"
    end

  end

end
