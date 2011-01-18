require 'spec_helper'

describe CsvLoader do

  TEST_FILE = "/tmp/test.csv"
  NUM_RECORDS = 5
  HEADER = %q("kind","title","location","description","start","finish","leaders")

  def csv_record
    kind  = %w(meeting non-county training event).to_a.sample
    title = "Test Record " + (1..999).to_a.sample.to_s
    year  = (2001 .. 2012).to_a.sample
    month = ("01" .. "12").to_a.sample
    day   = ("01" .. "30").to_a.sample
    start = "#{year}-#{month}-#{day}"
    %Q("#{kind}","#{title}","","","#{start}","","")
  end

  def generate_test_data
    output = HEADER + "\n"
    NUM_RECORDS.times { output << csv_record + "\n" }
    File.open(TEST_FILE, 'w') {|f| f.puts output }
  end

  before(:all) { generate_test_data }

  describe ".new" do
    context "when no file_name is specified" do
      it("raises an exception")    { expect{ CsvLoader.new }.to raise_error }
    end
    context "when using an input file_name" do
      it("returns a valid object") { CsvLoader.new(TEST_FILE).should_not be_nil }
    end
  end

  describe "#input_filename" do
    it "uses the init parameter as the input file name" do
      x = CsvLoader.new(TEST_FILE)
      x.input_filename.should == TEST_FILE
    end
  end

  describe "#input_file_exists?" do
    context "when using an existing file" do
      it "returns true" do
        x = CsvLoader.new(TEST_FILE)
        x.input_file_exists?.should == true
      end
    end
    context "when using a non-existing file" do
      it "returns false" do
        file = '/x/y'
        x = CsvLoader.new(file)
        x.input_file_exists?.should == false
      end
    end
  end

  describe "#num_input" do
  end

  describe "#num_successful" do
  end

  describe "#num_malformed" do
  end

  describe "#num_invalid" do
  end

  describe "#malformed_filename" do
  end

  describe "#invalid_filename" do
  end

  describe "#load_errors?" do
    context "when loading valid data"
    context "when loading malformed data"
    context "when loading invalid data"
  end

  describe "#error_message" do
  end

  describe "#success_message" do
  end

end

#using from the rakefile (rake db:csv_load)
#csv_load = CsvLoader.new(file)
#puts "Processed #{csv_load.processed} records."
#puts "Uploaded #{csv_load.uploaded} records."
#puts "Found #{csv_load.malformed} malformed records. (see #{csv_load.malformed_file})"
#puts "Found #{csv_load.invalid} invalid records. (see #{csv_load.invalid_file})"