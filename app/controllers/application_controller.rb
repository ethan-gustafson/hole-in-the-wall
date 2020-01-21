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
        
        def redirect_if_not_logged_in?
            if !logged_in?
                redirect to '/hole-in-the-wall'
            end
        end

		def current_user # identifies the current user.
			User.find(session[:user_id])
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