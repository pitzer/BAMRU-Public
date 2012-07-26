require 'spec_helper'

describe Event, "Scopes" do

  before(:each) do
    FactoryGirl.create(:event, :kind => "meeting")
    FactoryGirl.create(:event, :kind => "training")
    FactoryGirl.create(:event, :kind => "operation")
    FactoryGirl.create(:event, :kind => "other")
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

