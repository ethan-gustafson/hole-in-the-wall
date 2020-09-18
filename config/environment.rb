# The Bundler runtime allows its two main methods, Bundler.setup and Bundler.require, 
# to limit their impact to particular groups.
require 'bundler/setup'
Bundler.require

# .require requires all of the gems in the specified groups.

# The 'sinatra-activerecord' gem is finding the database.yml file for you. 
# You don't have to specify where the database.yml file is.
# BUT if you do set the database file only, it will automatically establish the connection to the database
# for you.

configure :test, :development, :production do
  set :database_file, "./database.yml"
end 

require_all 'app'