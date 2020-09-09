class StoresController < ApplicationController

    before { redirect_outside? }

    get "/stores" do # stores#index == get "/stores"
        popular_stores
        most_reviewed_stores

        erb :'/stores/main', locals: {
            title: "Store's index",
            css: false,
            banner: "/stylesheets/banners/loggedin.css",
            javascript: false
        }
    end

    # Sinatra allows named parameters, splat(wildcard (*)) paramaters, block parameters, regular expression matcher patterns,
    # query parameters and conditional paramaters.

    get "/stores/new" do # stores#new == get "/stores/new"
        erb :'/stores/new', locals: {
            title: "Create a Store",
            css: false,
            banner: "/stylesheets/banners/loggedin.css",
            javascript: false
        }
    end

     # store = Store.find_by(name: params[:name])

     post "/stores" do # stores#create == post "/stores"
        @store = Store.new(store_params)
        valid_user_store?

        if  @store.save
            redirect "/stores/#{@store.id}"
        else
            redirect "/stores/new"
        end
    end

    get "/stores/search" do
        erb :'/stores/search', locals: {
            title: "Search Stores",
            css: false,
            banner: "/stylesheets/banners/loggedin.css",
            javascript: "/javascript/stores/Search.js"
        }
    end

    # if there is a state param AND a store name param,
    # AND if the states has the key, 

    post "/stores/results" do
        request_recieved = request.body.read
        parameters = JSON.parse(request_recieved, {symbolize_names: true})

        empty_stores = {stores: "Sorry, we couldn't find any stores"}.to_json
        # if there is a :state param AND a :name param,
        if parameters[:state] && parameters[:name]
            # and if the states hash has the key, return both results
            if states.has_key?(parameters[:state].to_sym) 
                # method goes here
                state_stores = store_names_by_state(parameters[:state])
                if state_stores.empty?
                    empty_stores
                else
                    searched = stores_search(state_stores, parameters[:name])
                    {stores: searched}.to_json
                end
                # If the states hash does not have a key of the :state params, search for the store name.
                # If the search comes up empty, redirect. Otherwise return the results.
            else
                if store_names(parameters[:name]).empty?
                    empty_stores
                else
                    {stores: @search_results}.to_json
                end
            end  
            # Else if there is no state param, check the name param. If it is empty, redirect, else show the results.
        elsif parameters[:state] == "" || parameters[:name] == ""
            if store_names(parameters[:name]).empty?
                empty_stores
            else
                {stores: @search_results}.to_json
            end
        else
            empty_stores
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
        key  = require_param(:store)
    
        hash = permit_params(
            key,
            :name, 
            :street,
            :city,
            :zip_code,
            :description,
            :website
        )
        hash[:store].store(:user_id, params[:store][:user_id]) if params[:store][:user_id]
        hash[:store].store(:state, states[params[:store][:state].to_sym])
        hash[:store]
    end

end