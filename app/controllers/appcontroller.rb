class AppController < Sinatra::Base

    configure do
        set :public_folder, 'public' # tells the appcontroller where to find the public folder
        set :views, 'app/views' # tells the appcontroller where to find the views
        enable :sessions
        set :session_secret, "no_hack"
      end
    
    get '/hole-in-the-wall' do  # Done 
        erb :index # Offers a sign up or log in page
    end

    get '/hole-in-the-wall/home' do 
        erb :home # Shows all stores, shows account and log out buttons.
    end

    get '/hole-in-the-wall/login' do
        erb :login # has a login form.
    end

    post '/hole-in-the-wall/login' do # posts to login and redirects to the home if successful.
    @user = User.find_by(username: params[:username])
        binding.pry
        if !!@user && @user.authenticate(params[:password]) # If it is a valid user and the password is authenticated
			
            session[:user_id] = @user.id # we set the sessions user_id to equal the @user.id.
            redirect to '/hole-in-the-wall/home'
        else
            redirect '/hole-in-the-wall/error'
        end
    end

    get '/hole-in-the-wall/signup' do # has the sign up form
        erb :signup
    end

    post '/hole-in-the-wall/signup' do # signs up a user and redirects them to the home page or error page.
        user = User.new(params)
        if user.save
            redirect '/hole-in-the-wall/home'
        else
            redirect '/hole-in-the-wall/error'
        end
    end

    get '/hole-in-the-wall/account' do # Shows the users reviews, favorite stores and the logout button
        erb :account
    end

    get '/hole-in-the-wall/error' do # shows an error message that will tell the user to go back and log in or sign up.
        erb :error
    end

    get "/hole-in-the-wall/logout" do# logs out the user.
		session.clear
		redirect "/hole-in-the-wall"
	end

    helpers do
        def is_logged_in? # verifies that the session is true.
			!!session[:user_id]
		end

		def current_user # identifies the current user.
			User.find(session[:user_id])
		end
	end
end