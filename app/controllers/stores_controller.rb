class StoresController < ApplicationController

    before { redirect_outside? }

    get "/stores" do # stores#index == get "/stores"
        popular_stores
        most_reviewed_stores
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

    get "/stores/:id/fetch" do
        set_store
        reviews = []

        @store.reviews[0..9].each do |rev|
            reviews.push({
                id: rev.id,
                title: rev.title,
                content: rev.content,
                user_id: rev.user_id,
                store_id: rev.store_id,
                created_at: rev.created_at,
                updated_at: rev.updated_at,
                username: rev.user.username,
                current_user: current_user.id
            })
        end
        {reviews: reviews}.to_json
    end

    # if there is a state param AND a store name param,
    # AND if the states has the key, 

    post "/stores/results" do
        parameters = JSON.parse(request_parameters, {symbolize_names: true})

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
        hash[:store].store(:state, states[params[:store][:state].to_sym])
        hash[:store]
    end

end