ENV['GEM_PATH'] = "/home/aleak/.gems"

require 'rubygems'
Gem.clear_paths
require 'sinatra'

require File.dirname(File.expand_path(__FILE__)) + '/app'

run BamruApp
