require 'spec_helper'

describe CsvProcessor do

  describe "instance attributes" do
    subject { CsvProcessor.new }
    it { should respond_to(:rec_result)   }
    it { should respond_to(:csv_result)   }
    it { should respond_to(:input_body)   }
    it { should respond_to(:input_header) }
  end

  describe "public methods" do
    subject { CsvProcessor.new }
    it { should respond_to(:parse_csv_data)    }
    it { should respond_to(:save_records_to_db)   }
#    it { should respond_to(:save_records_to_file) }
  end

  describe "#parse_csv_data" do
    context "with valid input" do
      before(:each) { @csv = CsvProcessor.new(valid_test_data).parse_csv_data }
      specify { @csv.should be_a Hash        }
      specify { @csv.keys.length.should == 2 }
      specify { @csv[:valid_csv].should be_an Array }
      specify { @csv[:inval_csv].should be_nil      }
      specify { @csv[:valid_csv].length.should == NUM_INPUT }
    end

    context "with inval input" do
      before(:each) { @csv = CsvProcessor.new(inval_test_data).parse_csv_data }
      specify { @csv.should be_a Hash           }
      specify { @csv.keys.length.should == 2    }
      specify { @csv[:valid_csv].should be_an Array }
      specify { @csv[:inval_csv].should be_an Array }
      specify { @csv[:valid_csv].length.should == NUM_VALID_CSV }
      specify { @csv[:inval_csv].length.should == NUM_INVAL_CSV }
    end
  end

  describe "#rec_to_hash" do
    before(:each) do
      @obj = CsvProcessor.new(valid_test_data)
      @obj.parse_csv_data
      @rec = @obj.csv_result[:valid_csv].first
    end
    specify { @obj.rec_to_hash(@rec).should_not be_nil }
    specify { @obj.rec_to_hash(@rec).should be_a Hash  }
    specify { @obj.rec_to_hash(@rec).keys.length.should >= 5  }
  end

  describe "#save_records_to_db" do
    context "with valid input" do
      before(:each) do
        @obj = CsvProcessor.new(valid_test_data)
        @obj.parse_csv_data
        @rec = @obj.save_records_to_db
      end
      specify { @rec.should be_a Hash         }
      specify { @rec.keys.length.should == 2  }
      specify { @rec[:valid_rec].should be_an Array }
      specify { @rec[:inval_rec].should be_nil      }
      specify { @rec[:valid_rec].length.should == NUM_INPUT }
    end

    context "with inval input" do
      before(:each) do
        @obj = CsvProcessor.new(inval_test_data)
        @obj.parse_csv_data
        @rec = @obj.save_records_to_db
      end
      specify { @rec.should be_a Hash         }
      specify { @rec.keys.length.should == 2  }
      specify { @rec[:valid_rec].should be_an Array }
      specify { @rec[:inval_rec].should be_an Array }
      specify { @rec[:valid_rec].length.should == NUM_VALID_REC }
      specify { @rec[:inval_rec].length.should == NUM_INVAL_REC }
    end
  end

end
