
#
dir = File.dirname(File.expand_path(__FILE__))

env :RACK_ENV, 'production'

set :output, {:standard => 'log/cron_normal.log', :error => 'log/cron_error.log'}

every 12.hours do
  command "cd #{dir} && mv log/cron_normal.log log/cron_normal_backup.log"
  command "cd #{dir} && mv log/cron_error.log log/cron_error_backup.log"
end

every 1.day do
  command "cd #{dir} && bundle exec rake gcal_sync RACK_ENV=production"
end

