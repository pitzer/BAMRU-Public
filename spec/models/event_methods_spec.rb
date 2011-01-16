require 'spec_helper'

describe "Event / Local Methods" do

  before(:each) do
    Factory(:event, :kind => "meeting")
    Factory(:event, :kind => "event")
    Factory(:event, :kind => "training")
    Factory(:event, :kind => "non-county")
  end

  describe "Event.delete_all_records" do
    before(:each) { Event.delete_all_records }
    specify { Event.count.should == 0 }
  end

end
