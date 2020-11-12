class UsersController < ApplicationController
  get "/users/new" do
    redirect_current_user_back_to_root?
    erb :'/users/new'
  end

  post "/users" do
    @user = new_strong_params(params, User, :name, :username, :email, :password)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path 
    else
      flash[:credentials] = invalid_signup(params)
      redirect_to new_user_path
    end
  end

  get "/users/accounts/:id" do
    redirect_logged_out_user_to_login?
    @current_page = params[:id].to_i
    listed_users_by_accounts_page(@current_page)
    if @current_page > @last_page || @current_page < 1
      redirect_to users_path(@last_page)
    end
    erb :'users/index'
  end 

  get "/users/:id" do
    redirect_logged_out_user_to_login?
    if is_current_user
      @user            = current_user
      @reviews         = current_user_reviews
      @favorites       = current_user_favorites
      @stores          = current_user_stores
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

  patch "/users/:id" do
    if is_current_user && 
       update_strong_params(params, User, current_user, :name, :username, :email)
      redirect_to user_path(current_user.id)
    else
      flash[:invalid_update] = "Invalid Edit"
      redirect_to user_path(current_user.id)
    end
  end

  get "/users/:id/delete" do
    redirect_logged_out_user_to_login?
    current_user.destroy
    session.clear
    redirect_to login_path
  end
end