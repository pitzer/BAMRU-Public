require 'integration_helper'

describe "VisiTeams Login" do

  include Capybara

  before(:each) do
    Capybara.app = VisiTeams::Application
    Capybara.javascript_driver = :envjs
    p = "123456"
    @u = User.create(:email => "x@x.com", :password => p, :password_confirmation => p)
  end

  context "successful login" do
    before(:each) { visit '/users/sign_in' }

    it "should render the login page" do
      page.body.should include "Sign in"
    end

    it "should be able to login successfully" do
      fill_in 'user_password', :with => '123456'
      fill_in 'user_email', :with => 'x@x.com'
      click_button "Sign in"
      page.body.should include("x@x.com")
    end

    it "should login using Warden::Test::Helpers" do
      login_as(@u)
      visit '/'
      page.body.should include("x@x.com")
    end
  end

end
