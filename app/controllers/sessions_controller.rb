class SessionsController < ApplicationController
  get "/login" do
    redirect_current_user_to_root?
    erb :'/sessions/login'
  end

  post "/" do
    @user = User.find_by_username(params[:user][:username])
    if !@user.nil? && @user.authenticate(params[:user][:password]) 
      session[:user_id] = @user.id 
      redirect_to root_path
    else
      flash[:credentials] = {
        invalid: "Authentication Failed.",
        username: params[:user][:username], 
        password: params[:user][:password]
      }
      redirect_to login_path
    end
  end

  get "/" do
    redirect_non_user_to_login?
    @home_feed_reviews = Review.last_five_reviews 
    erb :'/sessions/root'
  end

  get "/logout" do
    session.clear
    redirect_to login_path
  end
end