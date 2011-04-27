require 'digest/sha1'

# Generates CSV output from the database.

class CsvGenerator
  
  attr_accessor :headers

  def initialize
    @headers = %w(kind title location leaders start finish lat lon description)
    @records = Event.all
  end

  def output
    output_header + output_records
  end

  def digest
    Digest::SHA1.hexdigest(output)
  end

  private

  def output_header
    @headers.join(',') + "\n"
  end

  def output_event(event)
    @headers.map {|field| ts = "event.#{field}"; %Q("#{eval ts}")}.join(',')
  end

  def output_records
    @records.map {|e| output_event(e)}.join("\n")
  end

end

