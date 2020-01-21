class UsersController < ApplicationController

    get '/hole-in-the-wall' do  
        erb :'/users/index' # Offers a sign up or log in page.
    end

    post '/hole-in-the-wall' do
    @user_signup = User.new(:name => params[:name], :username => params[:username], :email => params[:email], :password => params[:password])
        if @user_signup.valid?
            @user_signup.save # If it is a valid user and the password is authenticated.
            session[:user_id] = @user_signup.id
            redirect '/home' # redirects leave the current method - loses the instance variable
        else
            erb :'/users/show_error'
        end
    end

    get '/login' do
        erb :'/users/login' # has a login form.
    end

    post '/login' do # posts to login and redirects to the home if successful.
    @user = User.find_by(:username => params[:username])
        
        if !!@user && @user.authenticate(params[:password]) # If it is a valid user and the password is authenticated.
            session[:user_id] = @user.id # we set the sessions user_id to equal the @user.id.
            redirect to '/home'
        else
            erb :'/users/show_error'
        end
    end

    get '/home' do 
        if logged_in?
        erb :'/users/show_home'
        else
            redirect to '/hole-in-the-wall'
        end
    end

    get '/users' do
        @users = User.all
        if logged_in?
            erb :'/users/show_all_users'
        else
            redirect to '/hole-in-the-wall'
        end
    end

    get '/users/:id' do
        @find_user = User.find_by_id(params[:id])
        if logged_in?
            erb :'/users/show_individual_user'
        else
            redirect to '/hole-in-the-wall'
        end
    end

    get '/account' do # Shows the users reviews, favorite stores and the logout button.
        @session_user = User.find_by(id: session[:user_id]) # gives you the correct user
        if logged_in?
        erb :'/users/show_account'
        else
            redirect to '/hole-in-the-wall'
        end
    end

    get '/error' do # shows an error message that will tell the user to go back and log in or sign up.
        erb :'/users/show_error'
    end

    get "/logout" do# logs out the user.
		session.clear
		redirect "/hole-in-the-wall"
	end

end