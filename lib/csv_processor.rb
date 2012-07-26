#require 'fastercsv'
require 'csv'

class CsvProcessor

  attr_accessor :rec_result, :csv_result, :input_header, :input_body

  def initialize(input = "")
    return if input.empty?
    @input_header = input.split("\n").first.chomp
    @input_body   = input.split("\n")[1..-1].map{|x| x.chomp}
    @csv_result, @rec_result = {}, {}
  end

  def parse_csv_data(input = @input_body)
    valid_csv = []
    inval_csv = nil
    input.each do |v|
      begin
        valid_csv << v.parse_csv
      rescue
        (inval_csv ||= []) << v
      end
    end
    @csv_result = {:valid_csv => valid_csv, :inval_csv => inval_csv}
  end

  def save_records_to_db(input = @csv_result[:valid_csv])
    valid = []
    inval = nil
    input.each do |i|
      e = Event.create(rec_to_hash(i))
      e.valid? ? valid << i : (inval||=[]) << i
    end
    @rec_result = {:valid_rec => valid, :inval_rec => inval}
  end

  def rec_to_hash(rec)
    hdr_a = @input_header.parse_csv
    hdr_a.reduce({}) {|a,v| a[v] = rec[hdr_a.index(v)]; a}
  end

  def save_records_to_file
    save_inval_csv_to_file
    save_inval_rec_to_file
  end

  private

  def save_inval_csv_to_file
    return if @csv_result[:inval_csv].nil?
    File.open(INVAL_CSV_FILENAME, 'w') do |f|
      f.puts @input_header
      @csv_result[:inval_csv].each {|r| f.puts r}
    end
  end

  def save_inval_rec_to_file
    return if @rec_result[:inval_rec].nil?
    File.open(INVAL_REC_FILENAME, 'w') do |f|
      f.puts @input_header
      @rec_result[:inval_rec].each do |r|
        f.puts r.map {|e| %Q("#{e}")}.join(",")
      end
    end
  end

end
