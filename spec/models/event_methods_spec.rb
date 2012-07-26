require 'spec_helper'

describe Event, "Public Methods" do

  before(:each) do
    FactoryGirl.create(:event, :kind => "meeting")
    FactoryGirl.create(:event, :kind => "training")
    FactoryGirl.create(:event, :kind => "operation")
    FactoryGirl.create(:event, :kind => "other")
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
