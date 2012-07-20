require 'rubygems'
require 'bundler/setup'

# ===== App Config =====
set :app_name,    "borg"
set :application, "BAMRU-Public"
set :repository,  "https://github.com/andyl/#{application}.git"
set :vhost_names, %w(borg borgtest)
set :web_port,    9500

# ====== Deployment Stages =====
set :stages,        %w(vagrant devstage pubstage production)
set :default_stage, "vagrant"
require 'capistrano/ext/multistage'

# ===== Common Code for All Stages =====
load 'deploy'
share_dir = File.expand_path("config/deploy/shared", File.dirname(__FILE__))
require "#{share_dir}/tasks"

# ===== Package Definitions =====
require base_dir + "/config/deploy/shared/packages/passenger"
require base_dir + "/config/deploy/shared/packages/foreman"
require base_dir + "/config/deploy/shared/packages/sqlite"

