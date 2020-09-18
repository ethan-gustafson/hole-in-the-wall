require 'sinatra/base'
require 'sinatra/flash'
require 'time'
require_all 'app/helpers'
class ApplicationController < Sinatra::Base
    register Sinatra::Flash
    include ApplicationHelper
    include UserHelper
    include StoreHelper

    # The 'sinatra-activerecord' gem is finding the database.yml file for you. 
    
    # You don't have to specify where the database.yml file is.
    # BUT if you do set the database file only, it will automatically establish the connection to the database
    # for you.

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        set :database_file, "config/database.yml"
        enable :sessions
    end

    # Google will send you emails about your exposed API key for google maps on github.
    # Putting the api key in the gitignore will hide the key
    # Reading from the file directly will hide the api_key

    configure :test, :development do
        set :session_secret, File.read("config/keys/session_secret.txt")
        set :google_api, File.read("config/keys/API_KEY.txt")
    end

    configure :production do
        set :session_secret, ENV['SESSION_KEY']
        set :google_api, ENV['GOOGLE_API_KEY']
    end
    
end