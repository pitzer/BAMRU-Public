require 'spec_helper'

describe Settings do
  before(:each) { @obj = Settings.new }

  context "basic object creation" do
    specify {@obj.should_not be_nil}
  end

  describe "instance attributes" do
    specify { @obj.should respond_to(:password)  }
    specify { @obj.should respond_to(:site_role) }
    specify { @obj.should respond_to(:peer_url)  }
  end

  describe "default values" do
    specify { @obj.password.should  == "admin"              }
    specify { @obj.site_role.should == "Public"             }
    specify { @obj.peer_url.should  == "http://bamru.info"  }

  end

  describe "instance methods"

  describe "class methods"

  

end