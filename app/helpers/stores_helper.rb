module StoresHelper
  def stores_path
    "/stores"
  end
  
  def store_path(id) # Show
    "/stores/#{id}"
  end

  def new_store_path # New
    "/stores/new"
  end

  def edit_store_path(id) # Edit
    "/stores/#{id}/edit"
  end

  def search_results_path
   "/stores/search-results"
  end

  # Method chaining is allowed when the previous method called returns an ActiveRecord::Relation.
  # The following methods return an ActiveRecord::Relation:
  # select, order, where, all, group, joins, limit, and includes.

  # Scoping will also return ActiveRecord::Relations.

  # The `as_json` method, converts an ActiveRecord::Relation into an Array of Associative Arrays(Hashes)
  # If your query doesn't return a match, it will return an empty ActiveRecord::Relation array. 

  # If you call it on a method like find_by, it will return a hash only, because find_by doesn't return an 
  # ActiveRecord::Relation. It returns an instance of the class.

  # The difference between select and pluck is that pluck converts a database result into an array, without constructing
  # ActiveRecord Objects.

  def invalid_resource?
    set_store
    if current_user.id.equal?(@store.user_id)
      @store 
    else
      redirect_to store_path(@store.id)
    end
  end

  def valid_state?
    if states.any? { |k, v| v.eql?(params[:state]) }
      @stores = Store.where(state: params[:state])
    else
      @stores = Store.first(10)
    end
  end

  # The store_names method is used when the user decides to search without a state param.

  def store_names(name)
    stores = Store.order(name: :asc)
    stores_search(stores, name.downcase)
  end

  # Both store_names_by_state(state_param) && store_names(name) return an array of associative arrays.

  def stores_search(array, search_param)
    @search_results = []

    array.each do |store|
      if store.name.respond_to?(:downcase)
        store.name.downcase.include?(search_param) ? @search_results << store : next
      end
    end
    @search_results
  end

  def search_conditions(params)
    if !params[:state].blank? && !params[:name].blank?
      if states.has_key?(params[:state].to_sym) 
        flash[:search_results] = stores_search(store_names_by_state(params[:state]), params[:name])
      else
        flash[:search_results] = ["No results found"]
      end
    elsif !params[:state].blank? && params[:name].blank?
      if states.has_key?(params[:state].to_sym) 
        flash[:search_results] = Store.where(state: params[:state].to_sym)
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
  end
end