require 'spec_helper'

describe Event, "Scopes" do

  before(:each) do
    Factory(:event, :kind => "meeting")
    Factory(:event, :kind => "training")
    Factory(:event, :kind => "operation")
    Factory(:event, :kind => "other")
  end

  describe "#meetings" do
    it "returns the correct number of records" do
      Event.meetings.count.should == 1
    end
  end


  describe "#training" do
    it "returns the correct number of records" do
      Event.trainings.count.should == 1
    end
  end

  describe "#operation" do
    it "returns the correct number of records" do
      Event.operations.count.should == 1
    end
  end

  describe "#other" do
    it "returns the correct number of records" do
      Event.others.count.should == 1
    end
  end

end

