module StoreHelper

    def set_store
        @store = Store.find_by_id(params[:id]) 
    end

    # store_names_by_state is used when the user just searches for all states by state.

    def store_names_by_state(state_param)
        # Store.where(:state => "FL").pluck(:name)
        state = state_param.to_sym
        results = Store.where("state = ?", states[state]).pluck(:id, :name, :state).sort
        results
    end

    # The store_names method is used when the user decides to search without a state param.

    def store_names(name)
        # Store.order(name: :asc).pluck(:name) will return an array of all of the store names in order from a-z.

        stores = Store.order(name: :asc).pluck(:id, :name, :state)
        search_param = name.downcase

        stores_search(stores, search_param)
    end

    # Both store_names_by_state(state_param) && store_names(name) return an array.

    def stores_search(array, search_param)
        @search_results = []
        array.each do |store|
            if store[1].respond_to?(:downcase)
                store[1].downcase.include?(search_param) ? @search_results << {id: store[0], name: store[1], state: store[2]} : next
            end
        end

        @search_results
    end

    # Popular stores means most favorited stores. It will grab the last 5 popular stores out of the bunch based on where
    # the store is located. The MAX() function returns the largest value of the selected column.

    # Both popular_stores and most_reviewed_stores return a hash. Makes sense, as we want the name and its corresponding
    # value for the highest number of favorites and reviews of 5 stores.

    def popular_stores # you could turn this into a linked list
        # Store.select(:name).joins(:favorites).group(:name).order(favorites: :asc).maximum(:store_id)
        @popular_stores = Store.limit(5).select(
            :name
        ).joins(
            :favorites
        ).group(
            :name
        ).order(
            favorites: :asc
        ).maximum(
            :store_id
        )
    end

    # most_reviewed_stores will grab the last 5 most reviewed stores out of the bunch based on where the store is located.

    def most_reviewed_stores
        # Store.select(:name).joins(:reviews).group(:name).order(reviews: :asc).maximum(:store_id)
        @most_reviewed_stores = Store.limit(5).select(
            :name
        ).joins(
            :reviews
        ).group(
            :name
        ).order(
            reviews: :asc
        ).maximum(
            :store_id
        )
    end

    def invalid_resource?
        if current_user.id == set_store.user_id 
             @store 
        else
             redirect "/stores/#{@store.id}"
        end
    end

    def valid_user_store?
        if current_user.id == @store.id 
            @store
        else
            @store = false
        end
    end

    def valid_state?
       if states.any?{|k, v| v == params[:state]}
        @stores = Store.where(state: params[:state])
       else
        @stores = Store.all[0..9]
       end
    end
    
end