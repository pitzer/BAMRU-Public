source "http://rubygems.org"

# production
#gem 'rake', "~> 0.9.2"
# gem 'rake', "~> 0.8.7"
gem 'rake', "~> 0.9.2.2"
gem 'activerecord'
gem 'activesupport'
gem 'sinatra'
gem 'sinatra-cache-assets'
gem "gcal4ruby"
gem "sqlite3-ruby", "1.2.5", :require => "sqlite3"
gem "rack"
gem "rack-flash"
gem "fastercsv"
gem "daemons"
gem "whenever"
gem "thor"

if ENV['SYSNAME'] == 'ekel'
  group :development, :test do
    gem "vmc"
    gem "factory_girl"
    gem "ruby-debug", "0.10.0", :platform => :ruby_18
    gem "ruby-debug19",         :platform => :ruby_19 
    gem "capistrano"
    gem "capybara", "~> 1.1.1"
    gem "rspec", "~> 2.6.0"
    gem 'launchy'
    gem "capybara-webkit"  # depends on: "apt-get get libqt4-dev"
    gem "shotgun"
    gem "rcov"
    gem "thin"

    gem "drx"
    gem "hirb"
    gem "wirble"
    gem "interactive_editor"
    gem "awesome_print", :require => "ap"
  end
end
