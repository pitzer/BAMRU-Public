require 'spec_helper'

describe Event do

  context "basic Event creation" do
    it "should create an event" do
      t = Event.create(:title => "hello there")
      t.should_not be_nil
    end
  end

  describe ":kind validity checks" do
    context "when using valid :kind field" do
      specify { Factory.build(:event).should be_valid }
      specify { Factory.build(:event, :kind => 'meeting').should be_valid }
      specify { Factory.build(:event, :kind => 'training').should be_valid }
      specify { Factory.build(:event, :kind => 'event').should be_valid }
      specify { Factory.build(:event, :kind => 'non-county').should be_valid }
    end
    context "when using invalid :kind field" do
      specify { Factory.build(:event, :kind => 'invalid').should_not be_valid }
    end
  end

  describe ":check_dates validity checks" do
    context "when using valid date fields" do
      valid_dates = {:start => "2007-01-01", :finish => "2009-02-02" }
      specify { Factory.build(:event, valid_dates).should be_valid }
      valid_dates = {:start => "2007-01-01", :finish => "2007-01-01" }
      specify { Factory.build(:event, valid_dates).should be_valid }
    end
    context "when finish is earlier than start" do
      invalid_dates = {:start => "2007-01-01", :finish => "2006-02-02" }
      specify { Factory.build(:event, invalid_dates).should_not be_valid }
    end
    context "when start and finish are the same" do
      it "should set finish to nil" do
        identical_dates = {:start => "2007-01-01", :finish => "2007-01-01" }
        x = Factory(:event, identical_dates)
        x.finish.should be_nil
      end
    end
  end

  describe "digest/signature validity checks" do
    it "should not allow creation of duplicate events" do
      event_hash = {:title => "xx", :start => "2007-01-01", :location => "yy"}
      Factory(:event, event_hash)
      Factory.build(:event, event_hash).should_not be_valid
    end
  end

end
