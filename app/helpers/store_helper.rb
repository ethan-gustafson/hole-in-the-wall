module StoreHelper

    def set_store
        @store = Store.find_by_id(params[:id]) 
    end

    # Popular stores means most favorited stores. It will grab the last 5 popular stores out of the bunch based on where
    # the store is located. The MAX() function returns the largest value of the selected column.

    # Both popular_stores and most_reviewed_stores return a hash. Makes sense, as we want the name and its corresponding
    # value for the highest number of favorites and reviews of 5 stores.

    def popular_stores
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