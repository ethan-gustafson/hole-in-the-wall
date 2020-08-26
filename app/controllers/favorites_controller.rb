class FavoritesController < ApplicationController

    get '/favorites' do
        loggedin_banner
        @favorites = Favorite.all
        erb :'/favorites/index'
    end

    post '/favorites' do 
        @store = Store.find_by_id(params[:store_id])
        @favorited_store = Favorite.create(:user_id => current_user.id, :store_id => @store.id)
        redirect "/favorites"
    end

    delete '/favorites' do
        @favorite = Favorite.find_by_id(params[:favorite_id]) 
        @favorite.delete
        redirect "/favorites" 
    end

end