require 'spec_helper'

describe Event, "Scopes" do

  before(:each) do
    Factory(:action, :kind => "meeting")
    Factory(:action, :kind => "event")
    Factory(:action, :kind => "training")
    Factory(:action, :kind => "non-county")
  end

  describe "#meetings" do
    it "returns the correct number of records" do
      Event.meetings.count.should == 1
    end
  end

end

