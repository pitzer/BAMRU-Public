
require 'spec_helper'

describe Event, "Date Methods" do

  describe ".date_parse" do
    date = Time.parse("Jan-01-01")
    context "when giving a string input" do
      specify { Event.date_parse("Jan-2001").should == date}
    end
    context "when giving a date input" do
      specify { Event.date_parse(date).should == date }
    end
  end

  describe "Date Functions" do
    before(:each) do
      @first_year, @last_year = %w(2001-01-01 2003-12-31)
      date_array = %w(2001-04-01 2002-04-04 2003-03-04)
      @first_date, @mid_date, @last_date = date_array
      date_array.each {|x| FactoryGirl.create(:event, :start => x)}
      @range_data = %w(Jan-2001 Jan-2002 Jan-2003 Jan-2004)
    end
    describe ".first_event" do
      specify { Event.first_event.to_s.should == @first_date}
    end
    describe ".last_event" do
      specify { Event.last_event.to_s.should == @last_date}
    end
    describe ".first_year" do
      specify { Event.first_year.to_s.should == @first_year}
    end
    describe ".last_year" do
      specify { Event.last_year.to_s.should == @last_year}
    end
    describe ".range_array" do
      specify { Event.range_array.should == @range_data}
    end
  end

  describe "iCal Date Functions" do
    before(:each) { @obj = Event.new(:start => Time.now, :finish => Time.now) }
    specify { @obj.should respond_to(:dt_start) }
    specify { @obj.should respond_to(:dt_end)   }

    context "Meeting Actions" do
      before(:each) { @obj.kind = "meeting" }

      it "should contain a time stamp" do
        @obj.dt_start.should include("T")
      end

      it "should show meeting start time of 7:30" do
        @obj.dt_start.split("T").last.should == "193000"
      end
      
      it "should show meeting end time of 9:30" do
        @obj.dt_end.split("T").last.should == "213000"
      end
    end
  end

  describe "gCal Date Functions" do
    before(:each) { @obj = Event.new(:start => Time.now)}
    specify { @obj.should respond_to(:gcal_start)    }
    specify { @obj.should respond_to(:gcal_finish)   }
    specify { @obj.gcal_start.class.should == Time   }
    specify { @obj.gcal_finish.class.should == Time  }

    context "Meeting Actions" do
      before(:each) { @obj.kind = "meeting"}
      specify { @obj.gcal_start.class.should == Time   }
      specify { @obj.gcal_finish.class.should == Time  }
      it "should have the right hour for the event start" do
        @obj.gcal_start.hour.should == 19
      end
      it "should have the right hour for the event finish" do
        @obj.gcal_finish.hour.should == 21
      end
    end

    context "Other Actions, with a finish date" do
      before(:each) { @obj.finish = 1.day.from_now }
      specify { @obj.gcal_start.class.should == Time   }
      specify { @obj.gcal_finish.class.should == Time  }
    end

  end

end
