require 'spec_helper'

describe Event, "Public Methods" do

  before(:each) do
    Factory(:event, :kind => "meeting")
    Factory(:event, :kind => "training")
    Factory(:event, :kind => "operation")
    Factory(:event, :kind => "other")
  end

  describe ".delete_all_with_validation" do
    before(:each) { Event.delete_all_with_validation }
    it "deletes all records" do
      Event.count.should == 0
    end
  end

#  describe "#reset_first_in_year" do
#    context "when there are multiple records in the database" do
#
#    end
#    context "when there are no records in the database" do
#
#    end
#  end

end
