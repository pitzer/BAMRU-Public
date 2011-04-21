require File.expand_path(File.dirname(__FILE__) + '/csv_processor.rb')
require File.expand_path(File.dirname(__FILE__) + '/csv_digest.rb')

require 'digest/sha1'

class CsvLoader

  attr_reader :input_csv, :csv_results, :rec_results

  include CsvDigest
  extend CsvDigest

  def initialize(input_csv = "")
    @input_csv = input_csv
    add_error("Input data is empty.")            if input_csv.empty?
    add_error("Input duplicates existing data.") if duplicate_data?
    return if errors?
    @csp = CsvProcessor.new(@input_csv)
    @csv_results = @csp.parse_csv_data
    @rec_results = @csp.save_records_to_db
    @csp.save_records_to_file
  end

  def errors?
    defined?(@errors)
  end

  def warnings?
    @csv_results.try(:[], :inval_csv) || @rec_results.try(:[],:inval_rec)
  end

  def success_message
    inpn = num_input
    inps = pluralize(inpn, 'record')
    recn = num_valid_rec
    recs = pluralize(recn, 'record')
    "Success: #{recn} new Event #{recs} created from #{inpn} input #{inps}"
  end

  def warning_message
    csvn = num_inval_csv
    csvs = pluralize(csvn, 'record')
    csvlink = "<a href='/admin_inval_csv'>#{csvn} #{csvs}</a>"
    csvlink = csvn == 0 ? "#{csvn} #{csvs}" : csvlink
    recn = num_inval_rec
    recs = pluralize(recn, 'record')
    reclink = "<a href='/admin_inval_rec'>#{recn} #{recs}</a>"
    reclink = recn == 0 ? "#{recn} #{recs}" : reclink
    msg_csv = "#{csvlink} with invalid CSV formatting"
    msg_rec = "#{reclink} failed the database validation rules"
    warnings? ? "Warning: #{msg_csv}, #{msg_rec}" : ""
  end

  def error_message
    errors? ?  @errors.map {|e| "Error: #{e}"}.join('<br/>') : ""
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

  def pluralize(count, string)
    count == 1 ? string : string + "s"
  end
  
end