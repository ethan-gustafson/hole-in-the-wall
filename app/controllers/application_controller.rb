class ApplicationController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "no_hack"
      end

      helpers do
        def logged_in? # verifies that the session is true.
			!!session[:user_id]
		end

		def current_user # identifies the current user.
			User.find(session[:user_id])
        end
        
        def valid_params?
            params[:review].none? do |key,value|
                value == ""
            end
        end
    end

end