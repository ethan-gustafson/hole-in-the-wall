require_all "app/helpers"
class ApplicationController < Sinatra::Base
  register Sinatra::Flash
  include ApplicationHelper
  include SessionsHelper
  include UsersHelper
  include StoresHelper
  include ReviewsHelper
  include FavoritesHelper

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :database_file, "config/database.yml"
    enable :sessions
  end

  configure :test, :development do
    set :session_secret, File.read("config/keys/session_secret.txt")
    set :google_api, File.read("config/keys/API_KEY.txt")
  end

  configure :production do
    set :session_secret, ENV['SESSION_KEY']
    set :google_api, ENV['GOOGLE_API_KEY']
  end  
end