require 'spec_helper'

describe "Event / Scopes" do

  before(:each) do
    Factory(:event, :kind => "meeting")
    Factory(:event, :kind => "event")
    Factory(:event, :kind => "training")
    Factory(:event, :kind => "non-county")
  end

  describe "#meetings" do
    specify { Event.meetings.count.should == 1 }  
  end

end
