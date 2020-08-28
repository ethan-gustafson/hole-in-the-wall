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

    get "/most-favorited-stores" do
        loggedin_banner
        # @most_favorited = Store.select("stores.name, count(favorites.store_id").joins(:favorite).group("stores.name").order("count(favorites.store_id").limit(5)
    end

    get "/most-reviewed-stores" do
        loggedin_banner
         # ActiveRecord query goes here.
    end

    get "/search-stores" do
        loggedin_banner
        
    end

end