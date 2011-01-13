require 'spec_helper'

describe Event do

  context "basic Event creation" do
    it "should create an event" do
      t = Event.create(:title => "hello there")
      t.should_not be_nil
    end
  end

#  context "simple team creation" do
#    it "should create a team" do
#      t = Team.create(:name => "dddd")
#      t.should_not be_nil
#    end
#  end
#
#  context "when trying to create invalid teams" do
#    it "should not allow duplicate team names" do
#      x = Team.create(:name => "xxx")
#      x.should be_valid
#      y = Team.create(:name => "xxx")
#      y.should_not be_valid
#    end
#    it "does not allow invalid formats" do
#      x = Team.create(:name => "&xxx")
#      x.should_not be_valid
#    end
#    it "does not allow invalid formats" do
#      y = Team.create(:name => "-xxx")
#      y.should_not be_valid
#    end
#
#  end
#
#  describe "#set_url" do
#    it "should generate a valid url from a simple name" do
#      t = Team.create(:name => "zzz")
#      t.url.should == "zzz"
#    end
#    it "should generate a valid url from a complex name" do
#      t = Team.create(:name => "Zing Zang")
#      t.url.should == "zing_zang"
#    end
#    it "should handle underscores and dashes" do
#      t = Team.create(:name => "Zi-ng Za_ng")
#      t.url.should == "zi-ng_za_ng"
#    end
#  end
#
#  describe "#set_long_url" do
#    it "should generate a long_url from a simple name" do
#      t = Team.create(:name => "zzz")
#      t.long_url.should == "/zzz"
#    end
#    it "should generate a long_url from a complex name" do
#      t = Team.create(:name => "Zing Zang")
#      t.long_url.should == "/zing_zang"
#    end
#  end
#
#  describe "owner methods" do
#    before(:each) do
#      @u = Factory(:normal_user)
#      @t = @u.teams.create(:name => "eee")
#    end
#    describe "#owner?" do
#      it "has a valid user" do
#        @u.should be_valid
#      end
#      it "returns true after initially created" do
#        @t.owner?(@u).should be_true
#      end
#      it "returns true after being set" do
#        @t.set_owner(@u)
#        @t.owner?(@u).should be_true
#      end
#    end
#  end

end
