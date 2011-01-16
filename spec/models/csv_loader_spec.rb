require 'spec_helper'

describe CsvLoader do

  describe ".new" do
    context "when no file_name is specified" do
      it("raises an exception")    { expect{ CsvLoader.new }.to raise_error }
    end
    context "when using an input file_name" do
      it("returns a valid object") { CsvLoader.new("/x/y").should_not be_nil }
    end
  end

  describe "#input_file" do
    it "uses the init parameter as the input file name" do
      file = "/tmp/zzz"
      x = CsvLoader.new(file)
      x.input_filename.should == file
    end
  end

  describe "#input_file_exists?" do
    context "when using an existing file" do
      it "returns true" do
        file = "/tmp/zzz"
        system "touch #{file}"
        x = CsvLoader.new(file)
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

  describe "#processed" do
  end

  describe "#uploaded" do
  end

  describe "#malformed" do
  end

  describe "#invalid" do
  end

  describe "#malformed_file" do
  end

  describe "#invalid_file" do
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

#using from the controller...
#csv_load = CsvLoader.new(file)
#unless csv_load.input_file_exists?
#  set_flash_error("No input file")
#  redirect '/whatever'
#end
#set_flash_error(csv_load.error_message) if csv_load.load_errors?
#set_flash_notice(csv_load.success_message)
#
#using from the rakefile (rake db:csv_load)
#csv_load = CsvLoader.new(file)
#puts "Processed #{csv_load.processed} records."
#puts "Uploaded #{csv_load.uploaded} records."
#puts "Found #{csv_load.malformed} malformed records. (see #{csv_load.malformed_file})"
#puts "Found #{csv_load.invalid} invalid records. (see #{csv_load.invalid_file})"