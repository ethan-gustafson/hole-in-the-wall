class StoresController < ApplicationController

    before { redirect_if_not_logged_in? }

    get '/stores' do # index
        loggedin_banner
        erb :'/stores/index'
    end

    get '/stores/:id' do # show
        loggedin_banner_dynamic
        api_k
        
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

    # get "/search-stores" do
    #     loggedin_banner
        
    # end

end