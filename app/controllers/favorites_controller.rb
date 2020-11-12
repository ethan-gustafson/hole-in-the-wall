class FavoritesController < ApplicationController
  post '/favorites' do # favorites#create
    already_favorited?
    favorited_store = Favorite.new(user_id: current_user.id, store_id: params[:store_id])
    if favorited_store.save 
      redirect_to store_path(favorited_store.store_id)
    else
      flash[:favorite_error] = "There was an error in favoriting this store."
      redirect_to store_path(params[:store_id])
    end
  end

  get '/favorites/:id/delete' do # favorites#destroy
    favorite = Favorite.find_by_id(params[:id]) 
    favorite.delete
    redirect_to user_path(current_user.id)
  end

  private

  def already_favorited?
    if !Favorite.find_by_user_id_and_store_id(current_user.id, params[:store_id]).nil?
      flash[:favorite_error] = "This store is already in your favorites"
      redirect_to store_path(params[:store_id])
    end
  end
end