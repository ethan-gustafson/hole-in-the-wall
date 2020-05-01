class StoresController < ApplicationController

    before { redirect_if_not_logged_in? }

    get '/stores' do
        erb :'/stores/index' # all of the stores.
    end

    get '/stores/:id' do
        @store = Store.find_by_id(params[:id])
        erb :'/stores/show'
    end

    get '/my-stores' do
        @my_stores = UserStore.all
        erb :'/stores/my_stores'
    end

    get'/my-stores/:id' do
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