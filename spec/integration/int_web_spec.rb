require 'spec_helper'

describe "Web Pages" do

  include Capybara::DSL

  before(:each) do
    Capybara.app = BamruApp
  end

  context "public pages" do
    it "redirects the home page" do
      visit '/'
      page.status_code.should == 200
    end
    it "renders /calendar" do
      visit '/calendar'
      page.status_code.should == 200
    end
    it "renders /bamruinfo" do
      visit '/bamruinfo'
      page.status_code.should == 200
    end
    it "renders /join" do
      visit '/join'
      page.status_code.should == 200
    end
    it "renders /meetings_locations" do
      visit '/meeting_locations'
      page.status_code.should == 200
    end
    it "renders /sgallery" do
      visit '/sgallery'
      page.status_code.should == 200
    end
    it "renders /sarlinks" do
      visit '/sarlinks'
      page.status_code.should == 200
    end
    it "renders /donate" do
      visit '/donate'
      page.status_code.should == 200
    end
    it "renders /contact" do
      visit '/contact'
      page.status_code.should == 200
    end
    it "renders '/calendar.csv" do
      visit '/calendar.csv'
      page.status_code.should == 200
    end
    it "renders '/calendar.ical" do
      visit '/calendar.ical'
      page.status_code.should == 200
    end
  end

  context "admin pages" do
    before(:each) { ENV['ADMIN_LOGGED_IN'] = 'false' }
    context "without admin credentials" do
      it "does not render /admin_home" do
        visit '/admin_home'
        page.status_code.should == 401
      end
      it "does not render /admin_events" do
        visit '/admin_events'
        page.status_code.should == 401
      end
      it "does not render /admin_create" do
        visit '/admin_create'
        page.status_code.should == 401
      end
      it "does not render /admin_data" do
        visit '/admin_data'
        page.status_code.should == 401
      end
    end
    context "with admin credentials" do
      before(:each) { ENV['ADMIN_LOGGED_IN'] = 'true' }
      it 'renders /admin_home' do
        visit '/admin_home'
        page.status_code.should == 200
      end
      it 'renders /admin_events' do
        visit '/admin_events'
        page.status_code.should == 200
      end
      it 'renders /admin_data' do
        visit '/admin_data'
        page.status_code.should == 200
      end
      it 'renders /admin_settings' do
        visit '/admin_settings'
        page.status_code.should == 200
      end
    end
  end

end
