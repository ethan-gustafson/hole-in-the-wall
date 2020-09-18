class StoresController < ApplicationController

    before { redirect_outside? }

    get "/stores" do # stores#main
        popular_stores
        most_reviewed_stores
        
        @state ||= ""
        @stores_count = Store.all.count
        erb :'/stores/main'
    end

    get ("/stores/new"){ erb :'/stores/new' } # stores#new

     post "/stores" do # stores#create
        @store = Store.new(
            name: params[:store][:name],
            street: params[:store][:street],
            city: params[:store][:city],
            state: params[:store][:state],
            zip_code: params[:store][:zip_code],
            description: params[:store][:description],
            website: params[:store][:website],
            user_id: current_user.id
        )

        if @store.save
            redirect "/stores/#{@store.id}"
        else
            redirect "/stores/new"
        end
    end

    post "/stores/results" do # stores#create-search-results
        popular_stores
        most_reviewed_stores
        
        if !params[:state].blank? && !params[:name].blank?
            if states.has_key?(params[:state].to_sym) 
                flash[:search_results] = stores_search(store_names_by_state(params[:state]), params[:name])
            else
                flash[:search_results] = ["No results found"]
            end

        elsif !params[:state].blank? && params[:name].blank?

            if states.has_key?(params[:state].to_sym) 
                flash[:search_results] = store_names_by_state(params[:state])
            else
                flash[:search_results] = ["No results found"]
            end

        elsif params[:state].blank? && !params[:name].blank?
            if !store_names(params[:name]).empty?
                flash[:search_results] = @search_results
            else
                flash[:search_results] = ["No results found"]
            end
        else
            flash[:search_results] = Store.select(:id, :name, :state).order(state: :asc).as_json
        end
        redirect '/stores/search-results'
    end

    get '/stores/search-results' do # stores#search-results
        !!flash[:search_results] ? @results = flash[:search_results] : @results = []
        erb :'/stores/results'
    end

    get "/stores/:id" do # stores#show
        set_store
        @favorited = Favorite.find_by_user_id_and_store_id(current_user.id, params[:id])
        erb :'/stores/show'
    end

    get "/stores/:id/edit" do # stores#edit
        invalid_resource?
        erb :'/stores/edit'
    end

    patch "/stores/:id" do # stores#update
        invalid_resource?

        if @store.update(
            name: params[:store][:name],
            street: params[:store][:street],
            city: params[:store][:city],
            state: params[:store][:state],
            zip_code: params[:store][:zip_code],
            description: params[:store][:description],
            website: params[:store][:website]
        )
            redirect "/stores/#{@store.id}"
        else
            redirect "/stores/#{@store.id}"
        end
    end
end