class FavoritesController < ApplicationController

    get '/favorites' do 
        favorites = []
        favorites_objects = current_user.favorites
        favorites_objects.reverse.each do |fav|
            favorites <<  {id: fav.id, store: fav.store.name, store_id: fav.store_id}
        end
        {data: favorites}.to_json
    end

    post '/favorites' do 
        favorited_store = Favorite.new(
            user_id: current_user.id, 
            store_id: params[:store_id]
        )
        if favorited_store.save 
            redirect "/stores/#{favorited_store.store_id}"
        else
            flash[:favorite_error] = "This store is already in your favorites"
            redirect "/stores/#{favorited_store.store_id}"
        end
    end

    get '/favorites/:id' do
        favorite = Favorite.find_by_id(params[:id]) 
        favorite.delete
        redirect "/users/#{current_user.id}"
    end

end