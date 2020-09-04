class StoresController < ApplicationController

    before { redirect_outside? }

    get "/stores" do # stores#index == get "/stores"
        @stores = Store.all
        erb :'/stores/index', locals: {title: "Store's index"}
    end

    post "/stores" do # stores#create == post "/stores"
        if  @store = Store.create(store_params)
            redirect "/stores/#{@store.id}"
        else
            redirect "/stores/new"
        end
    end

    get "/stores/new" do # stores#new == get "/stores/new"
        erb :'/stores/new', locals: {title: "Create a Store"}
    end

    get "/stores/:id" do # stores#show == get "/stores/:id"
        set_store
        erb :'/stores/show', locals: {title: "#{@store.name}", javascript: "javascript/stores/Show.js"}
    end

    get "/stores/:id/edit" do # stores#edit == get "/stores/:id/edit"
        set_store
        erb :'/stores/edit', locals: {title: "Edit: #{@store.name}"}
    end

    patch "/stores/:id" do # stores#update == patch "/stores/:id"
        set_store
        if @store.update(store_params)
            redirect "/stores/#{@store.id}"
        else
            redirect "/stores/#{@store.id}"
        end
    end

    private

    def store_params
        key = require_param(:store)
    
        hash = permit_params(
            key,
            :name, 
            :address,
            :description,
            :website
        )
        hash[:store].store(:user_id, params[:store][:user_id]) if params[:store][:user_id]
        hash[:store]
    end

    def set_store
        @store = Store.find_by_id(params[:id]) 
    end

end