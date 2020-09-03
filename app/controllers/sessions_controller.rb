class SessionsController < ApplicationController

    get "/login" do  # sessions#new
        redirect_if_logged_in_user_accesses_a_not_logged_in_page?
        loggedout_banner
        css_file("stylesheets/users/login.css")
  
        erb :'/sessions/login' 
    end

    get "/" do # root#home
        redirect_if_not_logged_in?
        loggedin_banner
        api_k
        css_file("stylesheets/users/home.css")

        reviews_count = Review.all.count - 5 # The count will always be 5 less than the count of all reviews
        @home_feed_reviews = Review.all[reviews_count..Review.all.count].reverse # This will only show ten reviews from the most recent
        erb :'/sessions/root'
    end

    post "/" do # sessions#create
        @user = User.find_by(username: params[:username])
            
        if !!@user && @user.authenticate(params[:password]) # If it is a valid user and the password is authenticated.
            session[:user_id] = @user.id # we set the sessions user_id to equal the @user.id.
            redirect '/home'
        else
            redirect '/login'
        end
    end

    delete "/" do # sessions#destroy
		session.clear
		redirect "/"
    end

end