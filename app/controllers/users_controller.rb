require 'pry'
class UsersController < ApplicationController

    get '/' do 
      redirect_if_logged_in_user_accesses_a_not_logged_in_page?
      erb :'/users/new'
    end

    post '/' do
        if @user_signup = User.create(params) # If it is a valid user and the password is authenticated.
            session[:user_id] = @user_signup.id
            redirect '/home' # redirects leave the current method - loses the instance variable
        else
            redirect '/'
        end
    end

    get '/login' do  
      redirect_if_logged_in_user_accesses_a_not_logged_in_page?
      erb :'/users/login' 
    end

    post '/login' do # posts to login and redirects to the home if successful.
    @user = User.find_by(username: params[:username])
        
        if !!@user && @user.authenticate(params[:password]) # If it is a valid user and the password is authenticated.
            session[:user_id] = @user.id # we set the sessions user_id to equal the @user.id.
            redirect '/home'
        else
            redirect '/login'
        end
    end

    get '/home' do 
        redirect_if_not_logged_in?
        reviews_count = Review.all.count - 10 # The count will always be 10 less than the count of all reviews
        @home_feed_reviews = Review.all[reviews_count..Review.all.count].reverse # This will only show ten reviews from the most recent
        erb :'/users/show_home'
    end

    get '/users/collection/:id' do
        redirect_if_not_logged_in?

        page = params[:id]
        @user_count = User.all.count
        # page_number is the ending point of the range. page.to_i multiplied by 10, minus 1. (1*10) - 1 = 9.
        page_number = (page.to_i * 10) - 1 
        # users_to_show is the starting point of the range. 9 - 9 == 0.
        users_to_show = page_number - 9 
        # For example: User.all[users_to_show..page_number] == User.all[0..9], which will show ten records.
        @first = 1
        @current_page_number = page.to_i
        @previous = @current_page_number.to_i - 1
        @next = @current_page_number.to_i + 1
        # To calculate the last page, you divide the number of users by 10. This will always give you a whole number.
        # If you are on page 9, you are seeing users with an index of 80-89. page_number = (9 * 10) - 1 which equals 89.
        @last = (@user_count / 10) + 1
        @users = User.all[users_to_show..page_number]

        # if the current_page_number is less than first page OR current_page_number is greater than the last page, redirect.
        # else if the current page is the last page, change the last users shown to be the last ten.

        if @current_page_number < @first || @current_page_number > @last
            redirect "/users/collection/1"
        elsif @current_page_number == @last
            @users = User.all[(@user_count - 10)..(@user_count - 1)]
        end
        erb :'users/show_all_users'
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

    get "/logout" do# logs out the user.
		session.clear
		redirect "/"
	end

end