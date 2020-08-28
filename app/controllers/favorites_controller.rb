class FavoritesController < ApplicationController

    get '/favorites' do
        loggedin_banner
        @favorites = current_user.favorites
        erb :'/favorites/index'
    end

    post '/favorites' do 
        @favorited_store = Favorite.create(:user_id => current_user.id, :store_id => params[:store_id])
        redirect "/favorites"
    end

    delete '/favorites' do
        @favorite = Favorite.find_by_id(params[:favorite_id]) 
        @favorite.delete
        redirect "/favorites" 
    end

end