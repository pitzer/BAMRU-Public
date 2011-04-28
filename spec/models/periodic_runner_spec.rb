require 'spec_helper'

describe PeriodicRunner do
  TEST_NAME = "test"

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
    specify { @obj.should respond_to(:restart)                      }
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
      specify { @obj.name.should == "hi"                    }
      specify { @obj.state_file.should_not be_empty         }
      specify { @obj.delay_seconds.should == 33             }
      specify { File.exist?(@obj.state_file).should be_true }
    end
    context "with a code block" do
      before(:each) { @obj = PeriodicRunner.new {puts 'hi'} }
      specify { @obj.should_not be_nil                         }
      specify { @obj.code.should_not be_nil                    }
    end
  end
  
  # context ".reset_new" do
  #   it "reloads" do
  #     @obj1 = PeriodicRunner.new :name => "test1", :delay_seconds => 33
  #     @obj2 = PeriodicRunner.:name => "test1"
  #     @obj2.delay_seconds.should == 33
  #   end
  # end

#  context "running" do
#    before(:each) do
#      @obj = PeriodicRunner.new
#      @obj.delay_seconds = 5
#      @obj.name          = "test1"
#      @obj.start { x = 1 }
#    end
#    specify { @obj.pid.should_not == nil }
#  end

#  it "only allows one background process at a time"
#  it "is called from the settings object"
#  it "remembers its state if the server restarts"
#  it "restarts the task after it times out"
#  it "sends alert message if process term status is not nil"
#  it "doesn't leave zombie processes if the parent dies"
#  it "stops running if the parent dies"

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
