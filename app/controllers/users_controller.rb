require 'pry'
class UsersController < ApplicationController

    get "/" do 
      redirect_if_logged_in_user_accesses_a_not_logged_in_page?
      loggedout_banner
      css("stylesheets/users/new.css")

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
      css("stylesheets/users/login.css")

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
        api_k
        css("stylesheets/users/home.css")

        reviews_count = Review.all.count - 5 # The count will always be 5 less than the count of all reviews
        @home_feed_reviews = Review.all[reviews_count..Review.all.count].reverse # This will only show ten reviews from the most recent
        erb :'/users/home'
    end

    get "/users/index/:id" do
        redirect_if_not_logged_in?
        loggedin_banner_dynamic
        css("/stylesheets/users/users.css")

        @current_page = params[:id].to_i
        @user_count = User.all.count

        end_i = (@current_page * 20) - 1
        start_i = end_i - 19
        @users = User.all[start_i..end_i]

        # We have 20 users per page. Each page will have a group of 20 people. Every following page needs to show the next 20 users.
        # So we know that (1 * 20) is equal to 20. 20 users. For the array index, we minus 1 to set the ending index to 19.

        # To get the starting index (start_i), we subtract 19 from the end_i. Say we are on page 5. (5 * 20) is equal to 100.
        # 100 - 1 is equal to 99(end_i). 99 - 19 is equal to 80(start_i). User.all[start_i..end_i] will show twenty records, of 80 to 99.

        # But what if the user count goes over an even number? What if we have 106 users? 118 users?
        # In Ruby, 119 divided by 20 is still equal to 5. Dividing whole numbers returns whole numbers.
        # Any remainder will be from 1 to 19. So if there are no remainders (User.all.count % 20 == 0),
        # This means the number of users are divisible by 20, so there are no remainders. 

        # So if there are no remainders, we are on a page in the exact number of pages defined. If there are ANY remainders,
        # the last page is only one page ahead. So if we only had a remainder of four, there are four users above the number divisible by 20.
        # So if you used User.all[101..119], it will show any records in that range, regardless if index 119 is there or not.
        # User.all[101..119].count would return a count of 4. Only four users are in that range.

        @user_count % 20 == 0 ? @last_page = (@user_count / 20) : @last_page = (@user_count / 20) + 1

        if @current_page > @last_page || @current_page < 1
            redirect "/users/index/#{@last_page}"
        end
        erb :'users/index'
    end 

    get "/users/:id" do
        redirect_if_not_logged_in?
        loggedin_banner_dynamic
        css("/stylesheets/users/show.css")
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