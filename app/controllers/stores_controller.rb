class StoresController < ApplicationController

    before { redirect_if_not_logged_in? }

    get '/stores' do # index
        loggedin_banner
        erb :'/stores/index'
    end

    get '/stores/:id' do # show
        loggedin_banner_dynamic
        @store = Store.find_by_id(params[:id])
        erb :'/stores/show'
    end

    get '/store/new' do # new
        loggedin_banner_dynamic
        erb :'/stores/new'
    end

    post '/stores' do # create
        @store = Store.new(params)
        if @store.save
            redirect "/stores/#{@store.id}"
        end
    end

    get '/my-stores' do
        loggedin_banner
        @favorites = Favorite.all
        erb :'/stores/my_stores'
    end

    post '/my-stores' do 
        @store = Store.find_by_id(params[:store_id])
        @favorited_store = Favorite.create(:user_id => current_user.id, :store_id => @store.id)
        redirect "/my-stores"
    end

    delete '/my-stores' do
        @favorite = Favorite.find_by_id(params[:favorite_id]) 
        @favorite.delete
        redirect "/my-stores" 
    end

end