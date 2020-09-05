class StoresController < ApplicationController

    before { redirect_outside? }

    get "/stores" do # stores#index == get "/stores"
        @stores = Store.all
        erb :'/stores/main', locals: {
            title: "Store's index",
            css: false,
            banner: "/stylesheets/banners/loggedin.css",
            javascript: false
        }
    end

    # Sinatra allows named parameters, splat(wildcard (*)) paramaters, block parameters, regular expression matcher patterns,
    # query parameters and conditional paramaters.

    get "/stores/:id/index/:state?" do # stores#index == get "/stores"
        valid_state?
        erb :'/stores/index', locals: {
            title: "Store's index",
            css: false,
            banner: "/stylesheets/banners/loggedin.css",
            javascript: false
        }
    end

    get "/stores/new" do # stores#new == get "/stores/new"
        erb :'/stores/new', locals: {
            title: "Create a Store",
            css: false,
            banner: "/stylesheets/banners/loggedin.css",
            javascript: false
        }
    end

    post "/stores" do # stores#create == post "/stores"
        @store = Store.new(store_params)
        valid_user_store?

        if  @store.save
            redirect "/stores/#{@store.id}"
        else
            redirect "/stores/new"
        end
    end

    get "/stores/:id" do # stores#show == get "/stores/:id"
        set_store
        erb :'/stores/show', locals: {
            title: "#{@store.name}", 
            css: false,
            banner: "/stylesheets/banners/loggedin.css",
            javascript: "javascript/stores/Show.js"
        }
    end

    get "/stores/:id/edit" do # stores#edit == get "/stores/:id/edit"
        invalid_resource?
        
        erb :'/stores/edit', locals: {
            title: "Edit: #{@store.name}", 
            css: false,
            banner: "/stylesheets/banners/loggedin.css",
            javascript: false
        }
    end

    patch "/stores/:id" do # stores#update == patch "/stores/:id"
        invalid_resource?

        if  @store.update(store_params)
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

end