require 'spec_helper'

describe "Factory" do

  context "Using the Event Factory" do
    specify { Factory(:event).should_not be_nil }
    specify { Factory(:event).should be_valid }
  end

  context "Database Cleaning" do
    it "should have no event records when starting" do
      Event.count.should == 0
    end

    it "should be able to create a single record" do
      Factory(:event)
      Event.count.should == 1
    end

    it "should have no records when running the next spec" do
      Event.count.should == 0
    end
  end

end
