class SessionsController < ApplicationController

    get "/login" do  # sessions#new
        redirect_if_logged_in_user_accesses_a_not_logged_in_page?
        binding.pry
        erb :'/sessions/login' 
    end

    post "/" do # sessions#create
        @user = User.find_by(username: params[:username])
            
        if !!@user && @user.authenticate(params[:password]) # If it is a valid user and the password is authenticated.
            session[:user_id] = @user.id # we set the sessions user_id to equal the @user.id.
            redirect '/'
        else
            redirect '/login'
        end
    end

    get "/" do # root#home
        redirect_if_not_logged_in?

        reviews_count = Review.all.count - 5 # The count will always be 5 less than the count of all reviews
        @home_feed_reviews = Review.all[reviews_count..Review.all.count].reverse # This will only show ten reviews from the most recent
        erb :'/sessions/root'
    end

    get "/logout" do # sessions#destroy
		session.clear
		redirect "/login"
    end

end