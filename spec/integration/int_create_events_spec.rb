require 'spec_helper'
require 'capybara-webkit'
require 'capybara/rspec'

describe "Event Create & Edit" do

  include Capybara::DSL

  before(:each) do
    Capybara.app = BamruApp
    Capybara.javascript_driver = :webkit
    ENV['ADMIN_LOGGED_IN'] = 'true'
  end

  describe "basic page rendering" do
    it 'renders /admin_create' do
      visit '/admin_create'
      page.should_not be_nil
    end
  end

  describe "hiding & showing lat/lon", :js => true do

    context "when creating a new event" do
      it "has event type 'Meeting'" do
        visit '/admin_create'
        page.has_select?('kind_select', :selected => 'Meeting').should be_true
      end
      it "does not show the location row" do
        visit '/admin_create'
        should_be_hidden("Lat", "location_row")
      end
    end

    context "when editing a meeting" do
      before(:each) do
        event = Event.create!(:kind => "meeting", :title => 'meeting !!', :description => "hello")
        visit "/admin_edit/#{event.id}"
      end
      it "creates a valid record" do
        page.should_not be_nil
      end
      it "does not show the location row" do
        should_be_hidden("Lat", "location_row")
      end
    end

    context "when editing an operation" do
      before(:each) do
        event = Event.create!(:kind => "operation", :title => 'operation !!', :description => "hello")
        visit "/admin_edit/#{event.id}"
      end
      it "shows the location row" do
        should_not_be_hidden("Lat", "location_row")
      end
    end

    context "when changing from training to operation" do
      before(:each) do
        event = Event.create!(:kind => "training", :title => 'training !!', :description => "hello")
        visit "/admin_edit/#{event.id}"
      end
      it "shows the location row" do
        should_be_hidden("Lat", "location_row")
        select("Operation", :from => 'kind_select')
        should_not_be_hidden("Lat", "location_row")
      end
    end

    context "when changing from operation to meeting" do
      before(:each) do
        @lat = 32.5
        @lon = -125.2
        event = Event.create!(:kind => "operation", :title => 'xx', :lat => @lat, :lon => @lon)
        visit "/admin_edit/#{event.id}"
      end

      it "hides the location row" do
        should_not_be_hidden("Lat", "location_row")
        select("Meeting", :from => 'kind_select')
        should_be_hidden("Lat", "location_row")
      end

      it "preserves the location data if the type is reset" do
        should_not_be_hidden("Lat", "location_row")
        select("Meeting", :from => 'kind_select')
        should_be_hidden("Lat", "location_row")
        select("Operation", :from => 'kind_select')
        should_not_be_hidden("Lat", "location_row")
        should_not_be_hidden(@lat.to_s, "location_row")
      end

    end

  end

end
