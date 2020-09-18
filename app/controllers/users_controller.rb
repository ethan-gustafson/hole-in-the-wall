class UsersController < ApplicationController

    get "/users/new" do # users#new
        redirect_inside?
        erb :'/users/new'
    end

    post "/users" do # users#create
        @user = User.new(
            name: params[:user][:name], 
            username: params[:user][:username], 
            email: params[:user][:email], 
            password: params[:user][:password]
        )

        if @user.save
            session[:user_id] = @user.id
            redirect '/' 
        else
            flash[:invalid]     = "Invalid Signup"
            flash[:credentials] = {
                name: params[:user][:name], 
                username: params[:user][:username], 
                email: params[:user][:email], 
                password: params[:user][:password]
            }
            redirect '/users/new'
        end
    end

    get "/users/:id/accounts" do # users#index
        redirect_outside?

        @current_page = params[:id].to_i
        @user_count = User.count

        # We have 20 users per page. Each page will have a group of 20 people. Every following page needs to show the next 20 users.
        # So we know that (1 * 20) is equal to 20. 20 users. For the array index, we minus 1 to set the ending index to 19.

        # To get the starting index (start_i), we subtract 19 from the end_i. Say we are on page 5. (5 * 20) is equal to 100.
        # 100 - 1 is equal to 99(end_i). 99 - 19 is equal to 80(start_i). User.all[start_i..end_i] will show twenty records, of 80 to 99.

        end_i   = (@current_page * 20) - 1
        start_i = end_i - 19
        @users  = User.all[start_i..end_i]

        # But what if the user count goes over an even number? What if we have 106 users? 118 users?
        # In Ruby, 119 divided by 20 is still equal to 5. Dividing whole numbers returns whole numbers.
        # Any remainder will be from 1 to 19. So if there are no remainders (User.all.count % 20 == 0),
        # This means the number of users are divisible by 20, so there are no remainders. 

        @user_count % 20 == 0 ? @last_page = (@user_count / 20) : @last_page = (@user_count / 20) + 1

        # So if there are no remainders, we are on a page in the exact number of pages defined. If there are ANY remainders,
        # the last page is only one page ahead. So if we only had a remainder of four, there are four users above the number divisible by 20.
        # So if you used User.all[101..119], it will show any records in that range, regardless if index 119 is there or not.
        # User.all[101..119].count would return a count of 4. Only four users are in that range.

        if @current_page > @last_page || @current_page < 1
            redirect "/users/#{@last_page}/accounts"
        end
        erb :'users/index'
    end 

    get "/users/:id" do # users#show
        redirect_outside?
        # current user page is set to a true or false value
        is_current_user
        # if the current user page is true, return current_user, or return the correct user show page
        if @is_current_user
            @favorites = []
            favs_query = Favorite.includes(:store).where(favorites: {user_id: current_user.id}).pluck("favorites.id, stores.name, stores.id")

            favs_query.each do |fav|
                @favorites << {id: fav[0], store_name: fav[1], store_id: fav[2]}
            end

            @user            = current_user
            @reviews         = Review.limit(5).where(user_id: @user.id)
            
            @reviews_count   = Review.where(user_id: @user.id).count
            @favorites_count = Favorite.where(user_id: @user.id).count
            @stores_count    = Store.where(user_id: @user.id).count
        else
            @user               = User.find_by_id(params[:id])
            @user_reviews_count = Review.where(user_id: @user.id).count
            @reviews            = Review.limit(5).where(user_id: @user.id)
        end
        erb :'/users/show'
    end

    patch "/users/:id" do # users#update
        is_current_user

        if @is_current_user && current_user.update(
                name: params[:user][:name],
                username: params[:user][:username],
                email: params[:user][:email]
            )
            redirect "/users/#{current_user.id}"
        else
            flash[:invalid_update] = "Invalid Edit"
            redirect "/users/#{current_user.id}"
        end
    end

    get "/users/:id/delete" do # users#destroy
        current_user.destroy
        session.clear
        
        redirect "/login"
    end

    private

    def is_current_user
        @is_current_user = current_user.id == params[:id].to_i
    end

end