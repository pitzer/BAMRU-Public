require 'integration_helper'

describe "Profile Page" do

  include Capybara

  before(:each) do
    Capybara.app = VisiTeams::Application
    Capybara.javascript_driver = :envjs
    p = '123456'
    @u = User.create(:email => "x@x.com", :password => p, :password_confirmation => p)
  end

  context "after successful login" do
    before(:each) do
      login_as @u
      visit '/user/1/edit'
    end

    it "should render the profile page" do
      page.body.should include("x@x.com")
      page.body.should include("VisiTeams")
    end

    it "should be able to update my profile" do
      fill_in "First name",        :with => "hello"
      click_button "Update Profile"
      page.body.should include "was successfully updated."   # flash message
    end

  end
end
