ENV['RAILS_ENV'] ||= ENV['DEFAULT_RAILS_ENV']

env_settings = <<-EOF
APP_NAME
EOF

env_settings.each_line do |val|
  constant = val.chomp.strip
  eval "#{constant} ||= ENV['#{constant}']"
  abort "ERROR: Missing Environment Value (#{constant})" if constant.nil?
end

