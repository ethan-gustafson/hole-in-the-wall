class AppController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "no_hack"
      end
    
    get '/hole-in-the-wall' do # Done 
        erb :index
    end

    get '/hole-in-the-wall/home' do
        erb :home
    end

    get '/hole-in-the-wall/login' do
        erb :login
    end

    post '/hole-in-the-wall/login' do
    @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
			
            session[:user_id] = @user.id
            Helpers.is_logged_in?(session)
            redirect to '/hole-in-the-wall/home'
        else
            redirect '/hole-in-the-wall/error'
        end
    end

    get '/hole-in-the-wall/signup' do
        erb :signup
    end

    post '/hole-in-the-wall/signup' do
        user = User.new(params)
        if user.save
            redirect '/hole-in-the-wall/home'
        else
            redirect '/hole-in-the-wall/error'
        end
    end

    get '/hole-in-the-wall/account' do
        erb :account
    end

    get '/hole-in-the-wall/error' do
        erb :error
    end

    get "/hole-in-the-wall/logout" do
		session.clear
		redirect "/hole-in-the-wall"
	end

    helpers do
        def is_logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end
end