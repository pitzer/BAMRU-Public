SERVER       = "r210x.com"

set :application, "BAMRU TEST APP"
set :repository,  "http://github.com"
set :deploy_to,   "/home/aleak/papps/vtapp"

load 'deploy' if respond_to?(:namespace)
Dir['/vendor/plugins/*/recipes/*.rb'].each { |p| load p }

set :scm, :git

role :web, SERVER
role :app, SERVER
role :db,  SERVER, :primary => true

