class FavoritesController < ApplicationController

    get '/favorites' do 
        favorites = []
        favs_count = current_user.favorites.count
        if favs_count > 10
            favorites_objects = current_user.favorites[0..9]
            favorites_objects.reverse.each do |fav|
                favorites <<  {id: fav.id, store: fav.store.name, store_id: fav.store_id}
            end
            {data: favorites, favorites_exceeded_count: true}.to_json
        else
            favorites_objects = current_user.favorites
            favorites_objects.reverse.each do |fav|
                favorites <<  {id: fav.id, store: fav.store.name, store_id: fav.store_id}
            end
            {data: favorites}.to_json
        end
    end

    get "/users/:id/favorites/:fav_index_id" do
        redirect_outside?

        if params[:id].to_i != current_user.id
            redirect "/users/#{current_user.id}"
        end

        @current_page = params[:fav_index_id].to_i
        @favs_count = current_user.favorites.count

        end_i   = (@current_page * 20) - 1
        start_i = end_i - 19
        @favs  = current_user.favorites[start_i..end_i]
        
        @favs_count % 20 == 0 ? @last_page = (@favs_count / 20) : @last_page = (@favs_count / 20) + 1

        if @current_page > @last_page || @current_page < 1
            redirect "users/#{current_user.id}/favorites/1"
        end
        erb :'/favorites/index', locals: {
            title: "Signup", 
            css: false,
            banner: "/stylesheets/banners/loggedin.css",
            javascript: false
        }
    end

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