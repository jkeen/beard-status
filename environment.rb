
# require 'sinatra'
# require 'sinatra/static_assets'
# require "sinatra/subdomain"
# require 'erb'
# require 'rack/request'
# require 'active_record'
# require 'active_support'
# require 'sinatra/activerecord'
# require 'sqlite3'
# require 'mysql'

# Database setup.
ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml'))["production"])   

# Load Models
require 'models'

