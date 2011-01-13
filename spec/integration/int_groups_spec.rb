require "integration_helper"

describe "Groups" do

  include Capybara

  before(:each) do
    Capybara.app = VisiTeams::Application
    Capybara.javascript_driver = :envjs
    @u = Factory(:normal_user)
    @t = @u.teams.create(:name => "ttt")
    @g = @t.groups.create(:name => "group1", :users => [@u])
    @w = @t.workspaces.create(:name => "www", :users => [@u])
    @a = @w.apps.create(:name => "aaa")
  end

  context "upon successful login" do
    before(:each) do
      login_as(@u)
      visit '/teams/1?page=contacts'
    end

    it "should render the workspace page" do
      page.body.should include("group1")
      Group.count.should == 1
    end

    it "should be able to add a group" do
      Group.count.should == 1
      click_link("Create New Group")
      fill_in "group_name",        :with => "group2"
      click_button "Create Group"
      Group.count.should == 2
    end

    it "should be able to delete a group" do
      Group.count.should == 1
      click_button "grp_delete_1"
      Group.count.should == 0
    end

    it "should be able to edit a group" do
      click_button "grp_edit_1"
      fill_in "group_name",      :with => "bbb"
      click_button "Update Group"
      page.body.should include "was successfully updated" # flash message
      page.body.should include "bbb"
    end

  end

end
