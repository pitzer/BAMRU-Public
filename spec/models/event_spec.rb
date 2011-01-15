require 'spec_helper'

describe Event do

  context "basic Event creation" do
    it "should create an event" do
      t = Event.create(:title => "hello there")
      t.should_not be_nil
    end
  end

end
