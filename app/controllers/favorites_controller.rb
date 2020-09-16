class FavoritesController < ApplicationController

    post '/favorites' do 
        already_favorited?

        favorited_store = Favorite.new(
            user_id: current_user.id, 
            store_id: params[:store_id]
        )
        if favorited_store.save 
            redirect "/stores/#{favorited_store.store_id}"
        else
            flash[:favorite_error] = "There was an error in favoriting this store."
            redirect "/stores/#{params[:store_id]}"
        end
    end

    get '/favorites/:id/delete' do
        favorite = Favorite.find_by_id(params[:id]) 
        favorite.delete
        redirect "/users/#{current_user.id}"
    end

    private

    def already_favorited?
        if Favorite.find_by(user_id: current_user.id, store_id: params[:store_id])
            flash[:favorite_error] = "This store is already in your favorites"
            redirect "/stores/#{params[:store_id]}"
        end
    end

end