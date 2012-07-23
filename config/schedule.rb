# cron jobs - using javan/whenever

dir = File.dirname(File.expand_path(__FILE__))

env :RACK_ENV, 'production'

set :output, {:standard => 'log/cron_normal.log', :error => 'log/cron_error.log'}

every 1.day do
  command "cd #{dir}/log && find . -type f -name '*.log' | xargs -I file mv file file.bak"
end
