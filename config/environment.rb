# ENV["APP_ENV"] ||= "development". What does this mean?
# If there is no ENV["APP_ENV"], it will be set to the development mode.

# The Bundler runtime allows its two main methods, Bundler.setup and Bundler.require, 
# to limit their impact to particular groups.
require 'pry'
require 'bundler/setup'
Bundler.require

# .require requires all of the gems in the specified groups.

# The 'sinatra-activerecord' gem is finding the database.yml file for you. 
# You don't have to specify where the database.yml file is.

configure :development do
  ENV['SINATRA_ENV'] ||= "development"

  ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => "db/#{ENV['SINATRA_ENV']}.sqlite3"
  )
end

configure :production do
  db = URI.parse(ENV['DATABASE_URL'])
  
  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme = 'postgresql',
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end
require_all 'app'