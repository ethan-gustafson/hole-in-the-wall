class StoresController < ApplicationController
  before { redirect_logged_out_user_to_login? }

  get "/stores" do # stores#index
    @popular_stores = Store.popular_stores
    @most_reviewed_stores = Store.most_reviewed_stores
    @state = ""
    @stores_count = Store.count
    erb :'/stores/main'
  end

  get "/stores/new" do # stores#new
    erb :'/stores/new' 
  end

  post "/stores" do # stores#create
    @store = new_strong_params(
      params,
      Store,
      :name,
      :street,
      :city,
      :state,
      :zip_code,
      :description,
      :website,
      :user_id
    )
    @store.user_id = current_user.id
    if @store.save
      redirect_to store_path(@store.id)
    else
      redirect_to new_store_path
    end
  end

  post "/stores/results" do # stores#create-search-results
    search_conditions(params)
    redirect_to search_results_path
  end

  get '/stores/search-results' do # stores#search-results
    @results = 
      if flash[:search_results]
        flash[:search_results]
      else
        []
      end
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
    if update_strong_params(
      params, 
      Store, 
      @store, 
      :name, 
      :street, 
      :city, 
      :state, 
      :zip_code,
      :description,
      :website
    )
      redirect_to store_path(@store.id)
    else
      redirect_to store_path(@store.id)
    end
  end

  private

  def set_store
    @store = Store.find_by_id(params[:id]) 
    redirect_to stores_path if @store.nil?
  end

  def invalid_resource?
    set_store
    if !current_user.id.equal?(@store.user_id)
      redirect_to store_path(@store.id)
    end
  end
end