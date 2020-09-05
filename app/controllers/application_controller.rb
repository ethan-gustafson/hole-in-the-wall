require 'sinatra/base'
require 'sinatra/flash'
require 'pry'
require_all 'app/helpers'
class ApplicationController < Sinatra::Base
    register Sinatra::Flash
    include ApplicationHelper
    include StoreHelper

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, File.read("config/keys/session_secret.txt")
    end
    
end