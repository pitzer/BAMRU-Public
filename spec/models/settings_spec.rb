require 'spec_helper'

describe Settings do
  before(:each) do
    system "rm -f /tmp/asdf.yaml"
    @obj = Settings.new({ }, "/tmp/asdf.yaml")
  end

  context "basic object creation" do
    specify {@obj.should_not be_nil}
  end

  context "object creation with parameters" do
    it "takes one parameter" do
      @obj = Settings.new({"password" => "hello"})
      @obj.password.should == "hello"
    end
    it "take multiple parameters" do
      hsh = {"password" => "hello", "auto_sync" => "false"}
      @obj = Settings.new(hsh)
      @obj.password.should == "hello"
      @obj.auto_sync.should == "false"
    end
  end

  describe "instance attributes" do
    specify { @obj.should respond_to(:password)           }
    specify { @obj.should respond_to(:site_role)          }
    specify { @obj.should respond_to(:peer_url)           }
    specify { @obj.should respond_to(:auto_sync)          }
    specify { @obj.should respond_to(:alert_email)        }
    specify { @obj.should respond_to(:notif_email)        }
  end

  describe "default values" do
    specify { @obj.password.should    == "admin"              }
    specify { @obj.peer_url.should    == "http://bamru.info"  }
    specify { @obj.site_role.should   == "Public"             }
    specify { @obj.auto_sync.should   == "OFF"                }
    specify { @obj.alert_email.should == "akleak@gmail.com"   }
    specify { @obj.notif_email.should == "andy@r210.com"      }
  end

  describe "instance methods" do
    specify { @obj.should respond_to(:save)                       }
  end

  describe "validations" do
    it "should be valid when first created" do
      @obj.should be_valid
    end
    it "is invalid with bad value" do
      @obj.site_role = "Hello"
      @obj.should_not be_valid
    end
  end

  describe "#errors" do
    it "should not generates errors for valid objects" do
      @obj.valid?
      @obj.errors.keys.should be_empty
    end
    it "should generates errors for invalid objects" do
      @obj.site_role = "Hello"
      @obj.valid?
      @obj.errors.keys.should_not be_empty
    end
  end

  describe "#save" do
    it "should create a data file" do
      tmpfile = "/tmp/asdf.txt"
      system "rm -f #{tmpfile}"
      File.exist?(tmpfile).should_not be_true
      @obj.save(tmpfile)
      File.exist?(tmpfile).should be_true
    end
  end

  describe "object reloading" do
    it "should remember the objects values" do
      tmpfile = "/tmp/file.yaml"
      @obj.password = "HELLO"
      @obj.save(tmpfile)
      @obj2 = Settings.new({}, tmpfile)
      @obj2.password.should == "HELLO"
    end
  end

end