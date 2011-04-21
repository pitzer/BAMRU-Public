require File.expand_path(File.dirname(__FILE__) + '/csv_processor.rb')

require 'digest/sha1'

class CsvLoader

  attr_reader :input_csv, :csv_results, :rec_results

  def initialize(input_csv = "")
    @input_csv = input_csv
    add_error("Input data is empty.")            if input_csv.empty?
    add_error("Input duplicates existing data.") if duplicate_data?
    return if errors?
    @csp = CsvProcessor.new(@input_csv)
    @csv_results = @csp.parse_csv_data
    @rec_results = @csp.save_records_to_db
#    @csp.save_records_to_file
  end

  def input_digest(data = @input_csv)
    Digest::SHA1.hexdigest(data)
  end

  def duplicate_data?
    input_digest == CsvGenerator.new.digest
  end

  def errors?
    defined?(@errors)
  end

  def warnings?
    @csv_results.try(:[], :inval_csv) || @rec_results.try(:[],:inval_rec)
  end

  def success_message
    "Success"
  end

  def warning_message
    warnings? ? "Warnings" : ""
  end

  def error_message
    errors? ?  @errors.join(' - ') : ""
  end

  def num_input
    @csp.input_body.length
  end

  def num_valid_rec
    @rec_results[:valid_rec].length
  end

  def num_inval_rec
    x = @rec_results[:inval_rec]
    x.nil? ? 0 : x.length
  end

  def num_valid_csv
    @csv_results[:valid_rec].length
  end

  def num_inval_csv
    x = @csv_results[:inval_csv]
    x.nil? ? 0 : x.length
  end

  private

  def add_error(msg)
    (@errors ||= []) << msg
  end

  def add_warning(msg)
    (@warnings ||= []) << msg
  end
  
end