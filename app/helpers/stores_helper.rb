module StoresHelper
  def stores_path
    "/stores"
  end
  
  def store_path(id)
    "/stores/#{id}"
  end

  def new_store_path
    "/stores/new"
  end

  def edit_store_path(id)
    "/stores/#{id}/edit"
  end

  def search_results_path
   "/stores/search-results"
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

  def if_state_exists_and_name_exists(params)
    if states.has_key?(params[:state].to_sym) 
      flash[:search_results] = stores_search(store_names_by_state(params[:state]), params[:name])
    else
      flash[:search_results] = ["No results found"]
    end
  end

  def if_only_state_exists(params)
    if states.has_key?(params[:state].to_sym) 
      flash[:search_results] = Store.where(state: params[:state].to_sym)
    else
      flash[:search_results] = ["No results found"]
    end
  end

  def if_only_name_exists(params)
    if !store_names(params[:name]).empty?
      flash[:search_results] = @search_results
    else
      flash[:search_results] = ["No results found"]
    end
  end

  def search_conditions(params)
    if !params[:state].blank? && !params[:name].blank?
      if_state_exists_and_name_exists(params)
    elsif !params[:state].blank? && params[:name].blank?
      if_only_state_exists(params)
    elsif params[:state].blank? && !params[:name].blank?
      if_only_name_exists(params)
    else
      flash[:search_results] = Store.select(:id, :name, :state).order(state: :asc).as_json
    end
  end

  def get_states
    filepath     = File.join(".", "app", "assets", "files", "states.txt")
    file         = File.read(filepath)
    states_array = file.split("\n")
    states       = {}

    states_array.each do |state|
      key                = state.slice(0, state.index("-") - 1) # Florida
      value              = state.slice((state.length - 2), state.length) # FL
      states[key.to_sym] = value
    end
    states
  end

  def states
    @states ||= get_states
  end
end