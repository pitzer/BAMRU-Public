require 'spec_helper'

describe "Action / Local Methods" do

  before(:each) do
    Factory(:event, :kind => "meeting")
    Factory(:event, :kind => "event")
    Factory(:event, :kind => "training")
    Factory(:event, :kind => "non-county")
  end

  describe ".delete_all_with_validation" do
    before(:each) { Action.delete_all_with_validation }
    specify { Action.count.should == 0 }
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
