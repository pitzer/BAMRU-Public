require 'uri'
require 'net/http'

class AutoSync
  def self.runner_opts
    {
            :name => 'sync',
            :delay_seconds => 60 * 15
    }
  end

  def self.exec_sync
      settings = Settings.new
      return if settings.peer_url.nil?
      url = settings.peer_url + "/calendar.csv"
      uri = URI.parse(url)
      csv_text = Net::HTTP.get_response(uri.host, uri.path).body
      (puts "Not load ready"; return) unless CsvLoader.load_ready?(csv_text)
      Event.delete_all
      CsvLoader.new(csv_text)
      CsvHistory.save
  end

  def self.turn_on
    runner = PeriodicRunner.new(runner_opts) { exec_sync }
    runner.stop
    sleep 2
    runner.start
  end

  def self.turn_off
    runner = PeriodicRunner.new(runner_opts)
    runner.stop
  end
end