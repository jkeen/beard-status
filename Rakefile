require 'rubygems'
require 'rake'

namespace :db do
  desc "Auto migrate the database (destroys data)"
  task :automigrate do
    require 'environment'
    DataMapper.auto_migrate!
  end

  desc "Auto upgrade the database"
  task :autoupgrade do
    require 'environment'
    DataMapper.auto_upgrade!
  end
end