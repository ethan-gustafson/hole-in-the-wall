module StoreHelper

    def set_store
        @store = Store.find_by_id(params[:id]) 
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
        @stores = Store.all[0..10]
       end
    end
    
end