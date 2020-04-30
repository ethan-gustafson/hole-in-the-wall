class UsersController < ApplicationController

    get '/' do  
        erb :'/users/index' # Offers a sign up or log in page.
    end

    post '/' do
    @user_signup = User.new(:name => params[:name], :username => params[:username], :email => params[:email], :password => params[:password])
        if @user_signup.valid?
            @user_signup.save # If it is a valid user and the password is authenticated.
            session[:user_id] = @user_signup.id
            redirect '/home' # redirects leave the current method - loses the instance variable
        else
            erb :'/errors/show_error'
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
            erb :'/errors/show_error'
        end
    end

    get '/home' do 
        redirect_if_not_logged_in?
        erb :'/users/show_home'
    end

    get '/users' do
        redirect_if_not_logged_in?
        @users = User.all
            erb :'/users/show_all_users'
    end

    get '/users/:id' do
        redirect_if_not_logged_in?
        @find_user = User.find_by_id(params[:id])
        erb :'/users/show_individual_user'
    end

    get '/account' do # Shows the users reviews, favorite stores and the logout button.
        redirect_if_not_logged_in?
        @session_user = User.find_by(id: session[:user_id]) # gives you the correct user
        erb :'/users/show_account'
    end

    get '/error' do # shows an error message that will tell the user to go back and log in or sign up.
        erb :'/errors/show_error'
    end

    get "/logout" do# logs out the user.
		session.clear
		redirect "/"
	end

end