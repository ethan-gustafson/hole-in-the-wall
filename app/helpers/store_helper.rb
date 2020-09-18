module StoreHelper

    # Method chaining is allowed when the previous method called returns an ActiveRecord::Relation.
    # The following methods return an ActiveRecord::Relation:
    # select, order, where, all, group, joins, limit, and includes.

    # Scoping will also return ActiveRecord::Relations.

    # The as_json method, converts an ActiveRecord::Relation into an Array of Associative Arrays(Hashes)
    # If your query doesn't return a match, it will return an empty ActiveRecord::Relation array. 

    # If you call it on a method like find_by, it will return a hash only, because find_by doesn't return an 
    # ActiveRecord::Relation. It returns an object of the class.

    # The difference between select and pluck is that pluck converts a database result into an array, without constructing
    # ActiveRecord Objects.

    def set_store
        @store = Store.find_by_id(params[:id]) 
    end

    # store_names_by_state is used when the user just searches for all stores by state.

    def store_names_by_state(state)
        Store.select(:id, :name, :state).where("state = ?", state.to_sym).as_json
    end

    # The store_names method is used when the user decides to search without a state param.

    def store_names(name)
        stores = Store.select(:id, :name, :state).order(name: :asc).as_json
        stores_search(stores, name.downcase)
    end

    # Both store_names_by_state(state_param) && store_names(name) return an array of associative arrays.

    def stores_search(array, search_param)
        @search_results = []
        array.each do |store|
            if store["name"].respond_to?(:downcase)
                store["name"].downcase.include?(search_param) ? @search_results << store : next
            end
        end
        @search_results
    end

    # Both popular_stores and most_reviewed_stores return a hash. Makes sense, as we want the name and its corresponding
    # value for the highest number of favorites and reviews of 5 stores.

    # PostgreSQL initially presented an issue with these two queries below. PostgreSQL wouldn't accept them unless I had grouped together
    # all columns outside of the aggregate in the .group method.

    def popular_stores 
        @popular_stores = Store.select(
            "stores.id, 
            stores.name, 
            stores.state, 
            count(favorites.store_id) AS favorites_count"
        ).joins(:favorites).limit(5).group("stores.id, stores.name, stores.state").order("favorites_count DESC").as_json
    end

    def most_reviewed_stores
        @most_reviewed_stores = Store.select(
            "stores.id, 
            stores.name,
            stores.state, 
            count(reviews.store_id) AS reviews_count"
        ).joins(:reviews).limit(5).group("stores.id, stores.name, stores.state").order("reviews_count DESC").as_json
    end

    def invalid_resource?
        if current_user.id == set_store.user_id 
             @store 
        else
             redirect "/stores/#{@store.id}"
        end
    end

    def valid_state?
       if states.any?{|k, v| v == params[:state]}
        @stores = Store.where(state: params[:state])
       else
        @stores = Store.first(10)
       end
    end
    
end