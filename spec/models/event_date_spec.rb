require 'spec_helper'

describe "Event / Date Methods" do

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
      date_array.each {|x| Factory(:event, :start => x)}
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

end
