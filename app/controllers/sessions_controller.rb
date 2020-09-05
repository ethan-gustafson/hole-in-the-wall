class SessionsController < ApplicationController

    get "/login" do  # sessions#new
        redirect_inside?
        
        erb :'/sessions/login', locals: {
            title: "Login", 
            css: false,
            banner: "stylesheets/banners/loggedout.css",
            javascript: "javascript/session/Login.js"
        }
    end

    post "/" do # sessions#create

        # First find the user from the params
        @user = User.find_by(username: params[:user][:username])

        # if there is a user and the password does authenticate with the user
        if !!@user && !!@user.authenticate(params[:user][:password]) 
            # create a new session with a key of user_id pointing to the value of the logged in user id
            session[:user_id] = @user.id 
            redirect '/'
        else
            redirect '/login'
        end
    end

    get "/" do # root#home
        redirect_outside?

        # reviews_count will always be 5 less than the count of all reviews
        reviews_count = Review.all.count - 5 
        # @home_feed_reviews will only show ten reviews from the most recent
        @home_feed_reviews = Review.all[reviews_count..Review.all.count].reverse 

        erb :'/sessions/root', locals: {
            title: "Hole in the Wall", 
            css: false,
            banner: "stylesheets/banners/loggedin.css",
            javascript: false
        }
    end

    get "/logout" do # sessions#destroy
        # session.clear will remove any key/values in the session hash.
		session.clear
		redirect "/login"
    end

end