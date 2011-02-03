require 'integration_helper'

describe "Web Pages" do

  include Capybara

  before(:each) do
    Capybara.app = BamruApp
  end

  context "public pages" do
    it "redirects the home page" do
      visit '/'
      page.status_code.should == 404
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
    context "without admin credentials" do
      it "does not render /admin" do
        visit '/admin'
        page.status_code.should == 401
      end
      it "does not render /admin_show" do
        visit '/admin_show'
        page.status_code.should == 401
      end
      it "does not render /admin_new" do
        visit '/admin_new'
        page.status_code.should == 401
      end
      it "does not render /admin_load_csv" do
        visit '/admin_load_csv'
        page.status_code.should == 401
      end
    end
    context "with admin credentials" do
      before(:each) { page.driver.basic_authorize 'admin', 'admin' }
      it 'renders /admin' do
        visit '/admin'
        page.status_code.should == 200
      end
      it 'renders /admin_show' do
        visit '/admin_show'
        page.status_code.should == 200
      end
      it 'renders /admin_load_csv' do
        visit '/admin_load_csv'
        page.status_code.should == 200
      end
    end
  end

end
