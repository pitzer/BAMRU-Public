require 'spec_helper'

describe CsvLoader do

  describe "attributes" do
    subject { CsvLoader.new }
    it { should respond_to(:input_csv)   }
    it { should respond_to(:csv_results) }
    it { should respond_to(:rec_results) }
  end

  describe "public methods" do
    subject { CsvLoader.new }
    it { should respond_to(:num_input)            }
    it { should respond_to(:num_valid_rec)        }
    it { should respond_to(:num_valid_csv)        }
    it { should respond_to(:num_inval_rec)        }
    it { should respond_to(:num_inval_csv)        }
    it { should respond_to(:errors?)              }
    it { should respond_to(:warnings?)            }
    it { should respond_to(:error_message)        }
    it { should respond_to(:warning_message)      }
    it { should respond_to(:success_message)      }
    it { should respond_to(:duplicate_data?)      }
    it { should respond_to(:input_digest)         }
  end

  describe "#new" do
    context "with no input data" do
      it "should generate an error" do
        @obj = CsvLoader.new
        @obj.errors?.should be_true
      end
      it "should not generate a warning" do
        @obj = CsvLoader.new
        @obj.warnings?.should_not be_true
      end
    end
    context "with valid input data" do
      it "should not generate an error" do
        @obj = CsvLoader.new(valid_test_data)
        @obj.errors?.should_not be_true
      end
      it "should not generate an warning" do
        @obj = CsvLoader.new(valid_test_data)
        @obj.warnings?.should_not be_true
      end
    end
    context "with inval input data" do
      it "should not generate an error" do
        @obj = CsvLoader.new(inval_test_data)
        @obj.errors?.should_not be_true
      end
      it "should generate a warning" do
        @obj = CsvLoader.new(inval_test_data)
        @obj.warnings?.should be_true
      end
    end
    context "with duplicate input data" do
      it "should generate an error" do
        CsvLoader.new(valid_test_data)
        @obj = CsvLoader.new(CsvGenerator.new.output)
        @obj.errors?.should be_true
      end
      it "should not generate an warning" do
        CsvLoader.new(valid_test_data)
        @obj = CsvLoader.new(CsvGenerator.new.output)
        @obj.warnings?.should_not be_true
      end
    end
  end

  describe "#num_input" do
    context "with valid data" do
      it "should generate the right num_input" do
        CsvLoader.new(valid_test_data).num_input.should == NUM_INPUT
      end
    end
    context "with invalid data" do
      it "should generate the right num_input" do
        CsvLoader.new(inval_test_data).num_input.should == NUM_INPUT
      end
    end
  end

  describe "#num_valid_rec" do
    context "when loading valid data" do
      it "reports the correct number of successful records" do
        CsvLoader.new(valid_test_data).num_valid_rec.should == NUM_INPUT
        Event.count.should == NUM_INPUT
      end
    end
    context "when loading data with errors" do
      it "reports the correct number of successful records" do
        success = NUM_INPUT - NUM_INVAL_REC - NUM_INVAL_CSV
        CsvLoader.new(inval_test_data).num_valid_rec.should == success
        Event.count.should == success
      end
    end
    context "when re-loading identical data" do
      it "reports zero successful records" do
        data = valid_test_data
        Event.count.should == 0
        CsvLoader.new(data).num_valid_rec.should == NUM_INPUT
        Event.count.should == NUM_INPUT
        CsvLoader.new(data).num_valid_rec.should == 0
        Event.count.should == NUM_INPUT
      end
    end
    context "when there is existing data, and loading new data" do
      it "reports the correct number of new records" do
        success = NUM_INPUT - NUM_INVAL_REC - NUM_INVAL_CSV
        CsvLoader.new(valid_test_data)
        CsvLoader.new(inval_test_data).num_valid_rec.should == success
      end
      it "reports the correct number of total records" do
        total_records = NUM_INPUT - NUM_INVAL_REC - NUM_INVAL_CSV + NUM_INPUT
        CsvLoader.new(valid_test_data)
        CsvLoader.new(inval_test_data)
        Event.count.should == total_records
      end
    end

  end

  describe "#num_inval_csv" do
    context "when loading valid data" do
      it "reports no invalid records" do
        CsvLoader.new(valid_test_data).num_inval_csv.should == 0
      end
    end
    context "when loading data with errors" do
      it "reports the correct number of invalid records" do
        CsvLoader.new(inval_test_data).num_inval_csv.should == NUM_INVAL_CSV
      end
    end
  end

  describe "#num_inval_rec" do
    context "when loading valid data" do
      it "reports zero inval records" do
        CsvLoader.new(valid_test_data).num_inval_rec.should == 0
      end
    end
    context "when loading data with errors" do
      it "reports the correct number of inval records" do
        CsvLoader.new(inval_test_data).num_inval_rec.should == NUM_INVAL_REC
      end
    end
    context "when re-loading identical data" do
      it "reports that all records are invalid (duplicate)" do
        data = valid_test_data
        CsvLoader.new(data)
        CsvLoader.new(data).num_inval_rec.should == NUM_INPUT
      end
    end
  end

  describe "#error_message" do
    context "when loading valid data" do
      it "generates an empty error message" do
        x = CsvLoader.new(valid_test_data)
        x.error_message.should_not be_nil
        x.error_message.should be_empty
      end
    end
    context "when loading data with errors" do
      it "generates a non-empty error message" do
        x = CsvLoader.new("")
        x.error_message.should_not be_nil
        x.error_message.should_not be_empty
      end
    end
  end

  describe "#warning_message" do
    context "when loading valid data" do
      it "generates an empty warning message" do
        x = CsvLoader.new(valid_test_data)
        x.warning_message.should_not be_nil
        x.warning_message.should be_empty
      end
    end
    context "when loading data with warnings" do
      it "generates a non-empty warning message" do
        x = CsvLoader.new(inval_test_data)
        x.warning_message.should_not be_nil
        x.warning_message.should_not be_empty
      end
    end
  end

  describe "#success_message" do
    context "when loading valid data" do
      it "generates a success message" do
        CsvLoader.new(valid_test_data).success_message.should_not be_empty
      end
    end
    context "when loading data with errors" do
      it "generates a success message" do
        CsvLoader.new(inval_test_data).success_message.should_not be_empty
      end
    end
  end

end
