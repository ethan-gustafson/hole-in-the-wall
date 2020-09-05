class FavoritesController < ApplicationController

    post '/favorites' do 
        @favorited_store = Favorite.create(
            user_id: current_user.id, 
            store_id: params[:store_id]
        )
        redirect "/users/#{current_user.id}"
    end

    delete '/favorites' do
        @favorite = Favorite.find_by_id(params[:favorite_id]) 
        @favorite.delete
        redirect "/users/#{current_user.id}" 
    end

end