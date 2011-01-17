class CsvLoader

  # the CSV filename that is passed when the object is initialized
  attr_reader :input_filename

  # the text of the CSV input file
  attr_reader :input_text

  def initialize(input_filename)
    @input_filename = input_filename
#    @input_text = read_csv_text
  end

  def input_file_exists?
    File.exist? @input_filename
  end


end

#using from the controller...
#csv_load = CsvLoader.new(file)
#set_flash_error(csv_load.error_message) if csv_load.has_errors?
#set_flash_notice(csv_load.success_message)
#
#using from the rakefile (rake db:csv_load)
#csv_load = CsvLoader.new(file)
#puts "Processed #{csv_load.processed} records."
#puts "Uploaded #{csv_load.uploaded} records."
#puts "Found #{csv_load.malformed} malformed records. (see #{csv_load.malformed_file})"
#puts "Found #{csv_load.invalid} invalid records. (see #{csv_load.invalid_file})"

#post('/admin_load_csv') do
#  start_count = Event.count
#  system "mkdir -p #{DATA_DIR}"
#  system "rm -f #{CSV_FILE}"
#  system "rm -f /tmp/invalid.csv"
#  if params[:file].nil?
#    set_flash_error("Error - no CSV file was selected")
#    redirect '/admin_load_csv'
#  end
#  infile  = params[:file][:tempfile]
#  File.open(CSV_FILE, 'w') { |f| f.write infile.read }
#  csv_to_hash(read_csv).each do |r|
#    h = r.to_hash
#    h["kind"].downcase! unless h["kind"].nil?
#    record = Event.create(h)
#    unless record.valid?
#      File.open('/tmp/invalid.csv', 'a') {|f| f.puts r; f.puts record.errors.inspect}
#    end
#  end
#  finish_count = Event.count
#  if File.exist? '/tmp/malformed.csv'
#    csv_link = "malformed CSV records. (<a href='/malformed_csv'>view</a>)"
#    set_flash_error(" Warning: #{`wc -l /tmp/malformed.csv`.split(' ').first} #{csv_link}")
#  end
#  if File.exist? '/tmp/invalid.csv'
#    csv_link = "invalid CSV records. (<a href='/invalid_csv'>view</a>)"
#    set_flash_error(" Warning: #{`wc -l /tmp/invalid.csv`.split(' ').first} #{csv_link}")
#  end
#  set_flash_notice("CSV File Upload created #{finish_count - start_count} new event records.")
#  redirect '/admin_show'
#end
