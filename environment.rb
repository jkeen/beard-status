require 'bundler'
Bundler.setup

require 'sinatra'
require 'sinatra/static_assets'
require "sinatra/subdomain"
require 'erb'
require 'rack/request'
require "dm-core"
require 'dm-sqlite-adapter'
require 'dm-migrations'

# Database setup.
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{File.expand_path(File.dirname(__FILE__))}/db/production.db")

# Load Models
require 'models'