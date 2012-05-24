source "http://rubygems.org"

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
    gem "capistrano"
    gem "capistrano_colors"
    gem "capybara", "~> 1.1.1"
    gem "rspec", "~> 2.6.0"
    gem 'launchy'
    gem "capybara-webkit"  # depends on: "apt-get install libqt4-dev"
    gem "shotgun"
    gem "thin"

    gem "vagrant"

    gem "drx"
    gem "hirb"
    gem "wirble"
    gem "interactive_editor"
    gem "awesome_print", :require => "ap"
  end
end
