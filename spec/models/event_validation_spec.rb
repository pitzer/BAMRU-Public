require 'spec_helper'

describe Event, "Validations" do

  describe ":kind validity checks" do
    context "when using valid :kind field" do
      it "should be valid" do
        FactoryGirl.build(:event).should be_valid
        FactoryGirl.build(:event, :kind => 'meeting').should be_valid
        FactoryGirl.build(:event, :kind => 'training').should be_valid
        FactoryGirl.build(:event, :kind => 'operation').should be_valid
        FactoryGirl.build(:event, :kind => 'other').should be_valid
      end
    end
    context "when using invalid :kind field" do
      specify { FactoryGirl.build(:event, :kind => 'invalid').should_not be_valid }
    end
  end

  describe ":check_dates validity checks" do
    context "when using valid date fields" do
      valid_dates = {:start => "2007-01-01", :finish => "2009-02-02" }
      specify { FactoryGirl.build(:event, valid_dates).should be_valid }
    end
    context "when finish is earlier than start" do
      invalid_dates = {:start => "2007-01-01", :finish => "2006-02-02" }
      specify { FactoryGirl.build(:event, invalid_dates).should_not be_valid }
    end
    context "when finish is not specified" do
      valid_dates = {:start => "2007-01-01" }
      specify { FactoryGirl.build(:event, valid_dates).should be_valid }
    end
    context "when start and finish are the same" do
      it "should be valid" do
        valid_dates = {:start => "2007-01-01", :finish => "2007-01-01" }
        FactoryGirl.build(:event, valid_dates).should be_valid
      end
      it "should set finish to nil" do
        identical_dates = {:start => "2007-01-01", :finish => "2007-01-01" }
        x = FactoryGirl.create(:event, identical_dates)
        x.finish.should be_nil
      end
    end
  end

  describe "digest/signature validity checks" do
    it "should not allow creation of duplicate events" do
      event_hash = {:title => "xx", :start => "2007-01-01", :location => "yy"}
      FactoryGirl.create(:event, event_hash)
      FactoryGirl.build(:event, event_hash).should_not be_valid
    end
  end

end
