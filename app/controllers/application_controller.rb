require 'pry'
class ApplicationController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "no_hack"
      end

      helpers do

        def api_k
            filepath = "config/API_KEY.txt"
            @api_key = File.read(filepath)
        end

        def loggedin_banner
            @banner_filepath = "stylesheets/loggedin_banner.css"
        end

        def loggedin_banner_dynamic
            @banner_filepath = "/stylesheets/loggedin_banner.css"
        end

        def loggedout_banner
            @banner_filepath = "stylesheets/loggedout.css"
        end

        def css(file)
            @css_filepath = file
        end

        def logged_in? # verifies that the session is true.
			!!current_user
        end
        
        def redirect_if_not_logged_in?
            if !logged_in?
                redirect to '/'
            end
        end

        def redirect_if_logged_in_user_accesses_a_not_logged_in_page?
            if logged_in? 
                redirect '/home'
            end
        end

		def current_user # identifies the current user.
			@current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
        end
        
        def valid_params?
            params[:review].none? do |key,value|
                value == ""
            end
        end

        def validreview?
            if !logged_in? && current_user.id  != @user_review.user_id
                erb :'/reviews/error_no_access'
            end
        end

    end

end