SERVER       = "alt55.com"

set :application, "BAMRU TEST APP"
set :repository,  "git@github.com:andyl/BAMRU-Test.git"
set :deploy_to,   "/home/aleak/a/btest"

load 'deploy' if respond_to?(:namespace)
Dir['/vendor/plugins/*/recipes/*.rb'].each { |p| load p }

set :use_sudo, false

set :scm, :git

role :web, SERVER
role :app, SERVER
role :db,  SERVER, :primary => true

