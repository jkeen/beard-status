require "rubygems"

# This is really annoying.  It doesn't like require 'bundler' when passenger starts it, but needs require 'bundler' when capistrano tries to run a migration.  
begin
  require "bundler"
rescue LoadError
  # TTYB
ensure
  Bundler.setup # use require 'bundler/setup' for bundler 1.0
end

require 'sinatra'
require 'sinatra/static_assets'
require "sinatra/subdomain"
require 'erb'
require 'rack/request'
require 'active_record'
require 'active_support'
require 'sinatra/activerecord'
require 'sqlite3'
require 'yaml_db'
require 'mysql'

# Database setup.
ActiveRecord::Base.establish_connection(YAML::load(File.open('db/config.yml'))["production"])   

# Load Models
require 'models'

