puts ' PRODUCTION '.center(70, '-')

server 's2.bamru.org', :app, :web, :primary => true

set :user,      "deploy"
set :proxy,     "bamru1"
set :branch,    fetch(:branch, "master")
set :rails_env, fetch(:env,    "production")

server proxy, :app, :web, :db, :primary => true
