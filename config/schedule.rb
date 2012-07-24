# cron jobs - using javan/whenever

base_dir = File.expand_path("../../", __FILE__)

env :RACK_ENV, 'production'

set :output, {:standard => "#{base_dir}/log/cron_normal.log", :error => "#{base_dir}/log/cron_error.log"}

every 1.day, :at => '4:30 am' do
  command "cd #{base_dir}/log && find . -type f -name '*.log' | xargs -I file mv file file.bak"
end

every 1.day, :at => '4:45 am' do
  command "cd #{base_dir} && rake backup:db"
end

