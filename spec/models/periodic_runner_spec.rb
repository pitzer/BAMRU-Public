require 'spec_helper'

describe PeriodicRunner do
  TEST_NAME = "test"

  def delete_all_yaml_files
    system "rm -f /tmp/periodic*/*"
  end

  describe "instance attributes" do
    before(:each) { @obj = PeriodicRunner.new }
    specify { @obj.should respond_to(:pid)             }
    specify { @obj.should respond_to(:name)            }
    specify { @obj.should respond_to(:code)            }
    specify { @obj.should respond_to(:delay_seconds)   }
  end

  describe "instance methods" do
    before(:each) { @obj = PeriodicRunner.new }
    specify { @obj.should respond_to(:start)                        }
    specify { @obj.should respond_to(:stop)                         }
    specify { @obj.should respond_to(:running?)                     }
    specify { @obj.should respond_to(:state_file)                   }
    specify { @obj.should respond_to(:seconds_till_next_execution)  }
    specify { @obj.should respond_to(:seconds_from_last_execution)  }
  end

  context "basic object creation" do
    context "with no params or code" do
      before(:each) { @obj = PeriodicRunner.new }
      specify { @obj.should_not be_nil          }
      specify { @obj.name.should be_empty       }
      specify { @obj.state_file.should be_empty }
    end
    context "with a name attribute" do
      before(:each) do 
        opts = {:name => TEST_NAME, :delay_seconds => 33}
        PeriodicRunner.new(:name => TEST_NAME).remove_state_file
        @obj = PeriodicRunner.new(opts)
      end
      specify { @obj.should_not be_nil                      }
      specify { @obj.name.should == TEST_NAME               }
      specify { @obj.state_file.should_not be_empty         }
      specify { @obj.delay_seconds.should == 33             }
      specify { File.exist?(@obj.state_file).should be_true }
    end
    context "with a code block" do
      before(:each) { @obj = PeriodicRunner.new {puts 'hi'} }
      specify { @obj.should_not be_nil                         }
      specify { @obj.code.should_not be_nil                    }
    end
    context "with a delay_seconds param" do
      before(:each) { @obj = PeriodicRunner.new(:delay_seconds => 22) }
      specify { @obj.should_not be_nil                                }
      specify { @obj.delay_seconds.should == 22                       }
    end
  end
  
  describe ".new" do
    it "calls support methods during load" do
      PeriodicRunner.any_instance.should_receive(:save)
      PeriodicRunner.any_instance.
              should_receive(:read_params_from_yaml_file).
              and_return({})
      @obj1 = PeriodicRunner.new :name => "test1"
    end
    it "remembers the delay_second parameters" do
      @obj1 = PeriodicRunner.new :name => "test1", :delay_seconds => 33
      @obj2 = PeriodicRunner.new :name => "test1"
      @obj2.delay_seconds.should == 33
    end
    it "remembers the pid parameter" do
      @obj1 = PeriodicRunner.new :name => "test1", :pid => 99
      @obj2 = PeriodicRunner.new :name => "test1"
      @obj2.pid.should == 99
    end

    it "has executable code" do
      @obj1 = PeriodicRunner.new { "hi" }
      @obj1.code.call.should == "hi"
    end
  end

  describe ".reset_new" do
    it "forgets previous parameters" do
      @obj1 = PeriodicRunner.new :name => "test1", :delay_seconds => 33
      @obj2 = PeriodicRunner.reset_new :name => "test1"
      @obj2.delay_seconds.should == 0
    end
  end

  describe "#start" do
    it "raises error without a delay_seconds param" do
      @obj1 = PeriodicRunner.new { "hi" }
      lambda {@obj1.start}.should raise_error
    end
    it "raises no error with a delay_seconds param" do
      @obj1 = PeriodicRunner.new(:delay_seconds => 30) { "hi" }
      @obj1.delay_seconds.should == 30
      @obj1.delay_seconds.class.should == Fixnum
      @obj1.valid_delay?.should == true
      lambda {@obj1.start}.should_not raise_error
      @obj1.stop
    end
    it "remembers the pid" do
      delete_all_yaml_files
      @obj1 = PeriodicRunner.new(:name => "hi", :delay_seconds => 30) { "hi" }
      @obj1.start
      @obj2 = PeriodicRunner.new(:name => "hi") {"hi"}
      @obj2.pid.should == @obj1.pid
      @obj1.stop
    end
    it "raises an error if already running" do
      delete_all_yaml_files
      @obj1 = PeriodicRunner.new(:name => "hi", :delay_seconds => 30) { "hi" }
      @obj1.start
      @obj2 = PeriodicRunner.new(:name => "hi") {"hi"}
      lambda{@obj2.start}.should raise_error
      @obj1.stop
    end
  end

  describe "#running?" do
    it "shows false when not running" do
      @obj1 = PeriodicRunner.new(:delay_seconds => 30) { "hi" }
      @obj1.running?.should == false
    end
    it "shows true when running" do
      @obj1 = PeriodicRunner.new(:delay_seconds => 30) { "hi" }
      @obj1.start
      @obj1.running?.should == true
      @obj1.stop
    end
    it "remembers the process pid" do
      opts = {:name => 'hoho', :delay_seconds => 1000 }
      @obj1 = PeriodicRunner.new(opts) {"no"}
      @obj1.start
      @obj2 = PeriodicRunner.new(opts) {"no"}
      @obj2.running?.should == true
      @obj1.stop
    end
  end

  describe "#stop" do
    it "stops a running process" do
      @obj1 = PeriodicRunner.new(:delay_seconds => 30) { "hi" }
      @obj1.start
      @obj1.running?.should == true
      @obj1.stop
      sleep 1
      @obj1.running?.should == false
    end
  end

  describe "forking" do
    it "stops running if the parent dies" do
      opts = {:delay_seconds => 30, :name => "fork"}
      pid = Process.fork { @obj1 = PeriodicRunner.new(opts) { "hi" }}
      sleep 1
      Process.kill("SIGKILL", pid)
      sleep 1
      @obj2 = PeriodicRunner.new(opts) { "hi" }
      @obj2.running?.should == false
    end
  end

end

#describe Settings do
##  it "has a status (on/off)"
#end
#
#describe PeriodicBlock do
##  it "doesn't run for a public site"
##  it "doesn't run if peer isn't reachable"
##  it "overwrites data"
##  it "doesn't run if data is identical"
##  it "generates version history"
#end
