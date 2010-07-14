require "rubygems"
Bundler.setup # use require 'bundler/setup' for bundler 1.0
require 'sinatra'
require 'sinatra/static_assets'
require "sinatra/subdomain"
require 'erb'
require 'rack/request'
require 'active_record'
require 'sinatra/activerecord'
require 'sqlite3'

# Database setup.
set :database, "sqlite3:///db/production.db"

# Load Models
require 'models'
