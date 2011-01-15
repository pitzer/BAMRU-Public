require 'spec_helper'

describe "Patches to Time Class" do

  describe "Time.parse" do
    it "should return a valid date" do
      date = Time.parse "2001-01-01"
      date.class.should == Time
      date.year.should == 2001
      date.month.should == 1
    end
  end

  describe "Time.to_label" do
    specify { Time.parse("2001-01-01").to_label.should == "Jan-2001" }
  end

end
