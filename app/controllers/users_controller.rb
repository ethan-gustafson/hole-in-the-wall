require 'pry'
class UsersController < ApplicationController

    get "/" do 
      redirect_if_logged_in_user_accesses_a_not_logged_in_page?
      loggedout_banner
      css('<link rel="stylesheet" href="stylesheets/users/new.css" type="text/css">')

      erb :'/users/new'
    end

    post "/" do
        if @user_signup = User.create(params) # If it is a valid user and the password is authenticated.
            session[:user_id] = @user_signup.id
            redirect '/home' # redirects leave the current method - loses the instance variable
        else
            redirect '/'
        end
    end

    get "/login" do  
      redirect_if_logged_in_user_accesses_a_not_logged_in_page?
      loggedout_banner
      css('<link rel="stylesheet" href="stylesheets/users/login.css" type="text/css">')

      erb :'/users/login' 
    end

    post "/login" do # posts to login and redirects to the home if successful.
    @user = User.find_by(username: params[:username])
        
        if !!@user && @user.authenticate(params[:password]) # If it is a valid user and the password is authenticated.
            session[:user_id] = @user.id # we set the sessions user_id to equal the @user.id.
            redirect '/home'
        else
            redirect '/login'
        end
    end

    get "/home" do 
        redirect_if_not_logged_in?
        loggedin_banner
        css('<link rel="stylesheet" href="stylesheets/users/home.css" type="text/css">')

        reviews_count = Review.all.count - 10 # The count will always be 10 less than the count of all reviews
        @home_feed_reviews = Review.all[reviews_count..Review.all.count].reverse # This will only show ten reviews from the most recent
        erb :'/users/home'
    end

    get "/users/collection/:id" do
        redirect_if_not_logged_in?
        loggedin_banner_dynamic
        css('<link rel="stylesheet" href="/stylesheets/users/users.css" type="text/css">')

        page = params[:id]
        @user_count = User.all.count
        # page_number_to_user_end_i is the ending point of the range. page.to_i multiplied by 10, minus 1. (1*10) - 1 = 9.
        page_number_to_user_end_i = (page.to_i * 10) - 1 
        # user_start_i is the starting point of the range. 9 - 9 == 0.
        user_start_i = page_number_to_user_end_i - 9 
        # For example: User.all[user_start_i..page_number_to_user_end_i] == User.all[0..9], which will show ten records.
        @first = 1
        @current_page_number = page.to_i
        @previous = @current_page_number.to_i - 1
        @next = @current_page_number.to_i + 1
        # To calculate the last page, you divide the number of users by 10. This will always give you a whole number.
        # If you are on page 9, you are seeing users with an index of 80-89. page_number = (9 * 10) - 1 which equals 89.
        @last = (@user_count / 10) + 1
        @users = User.all[user_start_i..page_number_to_user_end_i]

        # if the current_page_number is less than first page OR current_page_number is greater than the last page, redirect.
        # else if the current page is the last page, change the last users shown to be the last ten.

        if @current_page_number < @first || @current_page_number > @last
            redirect "/users/collection/1"
        elsif @current_page_number == @last
            @users = User.all[(@user_count - 10)..(@user_count - 1)]
        end
        erb :'users/index'
    end 

    get "/users/:id" do
        redirect_if_not_logged_in?
        loggedin_banner_dynamic
        css('<link rel="stylesheet" href="/stylesheets/users/show.css" type="text/css">')
        # current user page is set to a true or false value
        @current_user_page = current_user.id == params[:id].to_i
        # if the current user page is true, return current_user, or return the correct user show page
        @current_user_page == true ? current_user :  @user = User.find_by_id(params[:id])
        erb :'/users/show'
    end

    get "/user/edit" do
        redirect_if_not_logged_in?
        loggedin_banner_dynamic

        current_user
        erb :'users/edit'
    end

    patch "/user/edit" do
        if current_user.update!(
            username: params[:user][:username], 
            name: params[:user][:name], 
            email: params[:user][:email]
        )
            redirect "/users/#{current_user.id}"
        else
            redirect '/user/edit'
        end
    end

    get "/user/delete" do
        redirect_if_not_logged_in?
        loggedin_banner_dynamic

        erb :'users/delete'
    end

    delete "/user/delete" do
        current_user.destroy
        session.clear
        
        redirect "/login"
    end

    get "/logout" do# logs out the user.
		session.clear
		redirect "/"
    end

end