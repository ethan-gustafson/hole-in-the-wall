class StoresController < ApplicationController

    before { redirect_outside? }

    get "/stores" do # stores#index == get "/stores"
        popular_stores
        most_reviewed_stores
        @state ||= ""
        @stores = Store.pluck(:id, :name, :state)
        @stores_count = Store.all.count
        erb :'/stores/main'
    end

    get ("/stores/new"){ erb :'/stores/new' } # stores#new == get "/stores/new"

     # store = Store.find_by(name: params[:name])

     post "/stores" do # stores#create == post "/stores"
        @store = Store.new(store_params)
        valid_user_store?

        if @store.save
            redirect "/stores/#{@store.id}"
        else
            redirect "/stores/new"
        end
    end

    # if there is a state param AND a store name param,
    # AND if the states has the key, 

    post "/stores/results" do
        popular_stores
        most_reviewed_stores
        # if there is a :state param AND a :name param,
        if params[:state] && params[:name]
            # and if the states hash has the key, return both results
            if states.has_key?(params[:state].to_sym) 
                # method goes here
                state_stores = store_names_by_state(params[:state])
                if state_stores.empty?
                    flash[:search_results] = ["No results found"]
                else
                    searched = stores_search(state_stores, params[:name])
                    flash[:search_results] = searched
                end
                # If the states hash does not have a key of the :state params, search for the store name.
                # If the search comes up empty, redirect. Otherwise return the results.
            else
                if store_names(params[:name]).empty?
                    flash[:search_results] = ["No results found"]
                else
                    flash[:search_results] = @search_results
                end
            end  
            # Else if there is no state param, check the name param. If it is empty, redirect, else show the results.
        elsif params[:state] == "" || params[:name] == ""
            if store_names(params[:name]).empty?
                flash[:search_results] = ["No results found"]
            else
                flash[:search_results] =  @search_results
            end
        else
            flash[:search_results] = ["No results found"]
        end
        redirect '/stores/search-results'
    end

    get '/stores/search-results' do
        if flash[:search_results]
            @results = flash[:search_results]
        else
            @results = []
        end
        erb :'/stores/results'
    end

    get "/stores/:id" do # stores#show == get "/stores/:id"
        set_store
        @favorited = Favorite.find_by(user_id: current_user.id, store_id: params[:id])
        erb :'/stores/show'
    end

    get "/stores/:id/edit" do # stores#edit == get "/stores/:id/edit"
        invalid_resource?
        erb :'/stores/edit'
    end

    patch "/stores/:id" do # stores#update == patch "/stores/:id"
        invalid_resource?

        if @store.update(store_params)
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
        hash[:store].store(:state, params[:store][:state].to_sym)
        hash[:store]
    end

end