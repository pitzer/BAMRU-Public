require 'spec_helper'

describe Action do

  context "basic Action creation" do
    it "should create an event" do
      t = Action.create(:title => "hello there")
      t.should_not be_nil
    end
  end

end
