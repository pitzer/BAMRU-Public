require 'digest/sha1'

class CsvHistory

  DIR = File.dirname(File.expand_path(__FILE__)) + "/../data/shared/history"

  def self.save
    timestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
    system "mkdir -p #{DIR}"
    file = "#{DIR}/#{timestamp}.csv"
    File.open(file, 'w') do |f|
      f.puts CsvGenerator.new.output
    end
    prune_old_files
  end

  def self.files
    `ls -1 #{DIR}`.split("\n")
  end

  def self.oldest_file
    files.last
  end

  def self.rm_oldest_file
    system "rm #{oldest_file}"
  end

  def self.prune_old_files
    rm_oldest_file until files.count < 100
  end

end

