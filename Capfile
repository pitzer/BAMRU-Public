require 'rubygems'
require 'bundler/setup'

# ====== Deployment Stages =====
set :stages,        %w(staging production)
set :default_stage, "staging"
set :user,          "vagrant"
set :proxy,         "public"

# ===== App Config =====
set :application, "BAMRU-Public"
set :app_name,    "public"
set :repository,  "https://github.com/andyl/#{application}.git"
set :vhost_names, %w(public pubtest)
set :web_port,    9500

# ===== Stage-Specific Code (config/deploy/<stage>) =====
require 'capistrano/ext/multistage'

# ===== Common Code for All Stages =====
load 'deploy'
base_dir = File.expand_path(File.dirname(__FILE__))
Dir.glob("config/deploy/shared/base/*.rb").each {|f| require base_dir + '/' + f}
Dir.glob("config/deploy/shared/recipes/*.rb").each {|f| require base_dir + '/' + f}

# ===== Package Definitions =====
require base_dir + "/config/deploy/shared/packages/nginx"
require base_dir + "/config/deploy/shared/packages/foreman"
require base_dir + "/config/deploy/shared/packages/sqlite"

# ===== Package Definitions =====
after 'deploy:setup',  'keys:upload'

namespace :keys do

  desc "upload keys"
  task :upload, :roles => :db do
    keyfile = File.expand_path("~/.borg_environment.yaml")
    tgtfile = "/home/#{user}/.borg_environment.yaml"
    upload keyfile, tgtfile
    run "chown -R #{user} #{tgtfile}"
    run "chgrp -R #{user} #{tgt_file}"
  end

end
