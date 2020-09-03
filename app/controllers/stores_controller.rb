class StoresController < ApplicationController

    before { redirect_if_not_logged_in? }

    get "/stores" do # stores#index == get "/stores"
        @stores = Store.all
        erb :'/stores/index'
    end

    post "/stores" do # stores#create == post "/stores"
        @store = Store.new(params)
        if @store.save
            redirect "/stores/#{@store.id}"
        end
    end

    get "/stores/new" do # stores#new == get "/stores/new"
        erb :'/stores/new'
    end

    get "/stores/:id" do # stores#show == get "/stores/:id"
        
        @store = Store.find_by_id(params[:id])
        erb :'/stores/show'
    end

    get "/stores/:id/edit" do # stores#edit == get "/stores/:id/edit"
        
        @store = Store.find_by_id(params[:id])
        erb :'/stores/edit'
    end

    patch "/stores/:id" do # stores#update == patch "/stores/:id"
        @store = Store.find_by_id(params[:id]) 
        if @store.update(params)
            redirect "/stores/#{@store.id}"
        else
            redirect "/stores/#{@store.id}"
        end
    end

end