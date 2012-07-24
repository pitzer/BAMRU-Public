ENV['RAILS_ENV'] ||= ENV['DEFAULT_RAILS_ENV']

env_settings = <<-EOF
APP_NAME
RACK_ENV
GCAL_USER_PROD
GCAL_PASS_PROD
GCAL_USER_TEST
GCAL_PASS_TEST
GMAIL_USER
GMAIL_PASS
EXCEPTION_ALERT_EMAILS
EOF

env_settings.each_line do |val|
  constant = val.chomp.strip
  eval "#{constant} ||= ENV['#{constant}']"
  abort "ERROR: Missing Environment Value (#{constant})" if constant.nil?
end

if RACK_ENV == 'production'
  GCAL_USER ||= GCAL_USER_PROD
  GCAL_PASS ||= GCAL_PASS_PROD
else
  GCAL_USER ||= GCAL_USER_TEST
  GCAL_PASS ||= GCAL_PASS_TEST
end

