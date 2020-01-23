class StoresController < ApplicationController

    get '/stores' do
        redirect_if_not_logged_in? # session works, users logged in will see 
        erb :'/stores/show_stores' # all of the stores.
    end

    get '/stores/:id' do
        redirect_if_not_logged_in?
        @store = Store.find_by_id(params[:id])
        erb :'/stores/show_individual_store'
    end

    get '/my-stores' do
        redirect_if_not_logged_in?
        @my_stores = UserStore.all
        erb :'/stores/my_stores'
    end

    get'/my-stores/:id' do
        redirect_if_not_logged_in?
        @user_store = UserStore.find_by_id(params[:id]) 
        @store = Store.find_by_id(@user_store.store_id)
        redirect "/stores/#{@store.id}"
    end

    post '/my-stores/:id' do 
        @store = Store.find_by_id(params[:id])
        @favorited_store = UserStore.create(:user_id => current_user.id, :store_id => @store.id)
        redirect to "/my-stores"
    end

    delete '/my-stores/:id' do
        @user_store = UserStore.find_by_id(params[:id]) 
        @user_store.delete
        redirect "/my-stores" 
    end

end