# ENV["APP_ENV"] ||= "development". What does this mean?
# If there is no ENV["APP_ENV"], it will be set to the development mode.

ENV["APP_ENV"] ||= "development"

# The Bundler runtime allows its two main methods, Bundler.setup and Bundler.require, 
# to limit their impact to particular groups.

require 'bundler/setup'

# .require requires all of the gems in the specified groups.

Bundler.require(:default, ENV['APP_ENV'])

# The 'sinatra-activerecord' gem is finding the database.yml file for you. 
# You don't have to specify where the database.yml file is.

ActiveRecord::Base.establish_connection(ENV["APP_ENV"].to_sym)
require_all 'app'