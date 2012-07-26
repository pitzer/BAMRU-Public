require 'spec_helper'

describe Event, "Callbacks" do

  describe "#cleanup_lat_lon_fields" do

    before(:each) do
      @lat = 38.2
      @lon = -125.5
    end

    it "zeroes out lat/lon for meetings" do
      event = FactoryGirl.build(:event, :kind => 'meeting', :lat => @lat, :lon => @lon)
      event.should be_valid
      event.lat.should be_nil
      event.lon.should be_nil
    end

    it "preserves lat/lon for operations" do
      event = FactoryGirl.build(:event, :kind => 'operation', :lat => @lat, :lon => @lon)
      event.should be_valid
      event.lat.should == @lat
      event.lon.should == @lon
    end
    
  end

end
