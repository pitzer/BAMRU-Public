require 'fastercsv'

class CsvProcessor

  attr_accessor :rec_result, :csv_result, :input_header, :input_body

  def initialize(input = "")
    return if input.empty?
    @input_header = input.to_a.first.chomp
    @input_body   = input.to_a[1..-1].map{|x| x.chomp}
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
  
end
