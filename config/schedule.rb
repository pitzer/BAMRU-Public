# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
#
dir = File.dirname(File.expand_path(__FILE__))

env :RACK_ENV, 'production'

set :output, {:standard => 'log/cron_normal.log', :error => 'log/cron_error.log'}

every 20.minutes do
  command "cd #{dir} && bundle exec rake data_import"
end

every 1.day do
  command "cd #{dir} && bundle exec rake gcal_sync"
end

every 1.week do
  command "echo Starting Log File Rotation at #{Time.now}"
  command "cd #{dir} && mv log/cron_normal.log log/cron_normal_backup.log"
  command "cd #{dir} && mv log/cron_error.log log/cron_error_backup.log"
end
