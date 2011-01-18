require 'spec_helper'

describe Action, "Scopes" do

  before(:each) do
    Factory(:action, :kind => "meeting")
    Factory(:action, :kind => "event")
    Factory(:action, :kind => "training")
    Factory(:action, :kind => "non-county")
  end

  describe "#meetings" do
    specify { Action.meetings.count.should == 1 }
  end

end
