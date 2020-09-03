require 'pry'
class UsersController < ApplicationController

    namespace "/users" do

        get "/new" do # users#new == get "/users/new"
            redirect_if_logged_in_user_accesses_a_not_logged_in_page?
            
            erb :'/users/new'
        end
      
        post "/" do # users#create == post "/users"
            if @user_signup = User.create(params) 
                session[:user_id] = @user_signup.id
                redirect '/' 
            else
                redirect '/users/new'
            end
        end

        get "/:id/accounts" do # index == get "/users/:id/accounts"
            redirect_if_not_logged_in?
    
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
                redirect "/users/#{@last_page}/accounts"
            end
            erb :'users/index'
        end 

        get "/:id" do # users#show == get "/users/:id"
            redirect_if_not_logged_in?
            # current user page is set to a true or false value
            @current_user_page = current_user.id == params[:id].to_i
            # if the current user page is true, return current_user, or return the correct user show page
            @current_user_page == true ? current_user :  @user = User.find_by_id(params[:id])
            erb :'/users/show'
        end

        patch "/:id" do # users#update == patch "/users/:id"
            if current_user.update!(
                username: params[:user][:username], 
                name: params[:user][:name], 
                email: params[:user][:email]
            )
                redirect "/users/#{current_user.id}"
            else
                redirect "/users/#{current_user.id}"
            end
        end

        delete "/:id/delete" do # users#destroy == delete "/users/:id/delete"
            current_user.destroy
            session.clear
            
            redirect "/login"
        end

    end

end