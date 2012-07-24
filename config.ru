ENV['GEM_PATH'] = "/home/aleak/.gems"

require 'rubygems'
Gem.clear_paths
require 'sinatra'

require File.expand_path(File.dirname(__FILE__)) + "/app"

run BamruApp
