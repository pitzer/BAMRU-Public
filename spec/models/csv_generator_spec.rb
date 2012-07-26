require 'spec_helper'

describe CsvGenerator do

  describe "attributes" do
    subject { CsvGenerator.new }
    it { should respond_to(:headers)     }
  end

  describe "public methods" do
    subject { CsvGenerator.new }
    it { should respond_to(:output)          }
    it { should respond_to(:digest)          }
  end

  describe "#new" do
    context "with no input data" do
      before(:each) do
        @obj = CsvGenerator.new
      end
      it "generates a valid object" do
        @obj.should_not be_nil
      end
    end
    context "with input data" do
      before(:each) do
        FactoryGirl.create(:event)
        @obj = CsvGenerator.new
      end
      it "generates a valid object" do
        @obj.should_not be_nil
      end
    end
  end

  describe "#output" do
    context "with no input data" do
      before(:each) do
        @obj = CsvGenerator.new
      end
      it "generates valid output" do
        @obj.output.should_not be_nil
      end
      it "generates no data records" do
        @obj.output.split("\n").length.should == 1
      end
    end
    context "with input data" do
      before(:each) do
        FactoryGirl.create(:event)
        @obj = CsvGenerator.new
      end
      it "generates a valid output" do
        @obj.output.should_not be_nil
      end
      it "generates one data records" do
        @obj.output.split("\n").length.should == 2
      end
    end
  end

  describe "#digest" do
    before(:each) do
      FactoryGirl.create(:event)
      @obj = CsvGenerator.new
    end
    it "generates output" do
      @obj.digest.should_not be_nil
    end
  end

end
