require 'rubygems'
require 'bundler/setup'
require File.expand_path('./lib/env_settings', File.dirname(__FILE__))

# ===== App Config =====
set :app_name,    "borg"
set :application, "BAMRU-Public"
set :repository,  "https://github.com/andyl/#{application}.git"
set :vhost_names, %w(bamru.info www.bamru.info bamru.org www.bamru.org borg)
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
require share_dir + "/packages/passenger"
require share_dir + "/packages/foreman"
require share_dir + "/packages/sqlite"

