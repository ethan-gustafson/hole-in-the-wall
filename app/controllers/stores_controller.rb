class StoresController < ApplicationController
  before { redirect_non_user_to_login? }

  get "/stores" do
    @popular_stores = Store.last_five_most_popular
    @most_reviewed_stores = Store.last_five_most_reviewed
    @state = ""
    @stores_count = Store.count
    erb :'/stores/main'
  end

  get "/stores/new" do
    erb :'/stores/new' 
  end

  post "/stores" do
    @store = Store.new(**new_store_params)
    @store.user_id = current_user.id
    if @store.save
      redirect_to store_path(@store.id)
    else
      redirect_to new_store_path
    end
  end

  post "/stores/results" do
    search_conditions(params)
    redirect_to search_results_path
  end

  get '/stores/search-results' do
    @results = 
      if flash[:search_results]
        flash[:search_results]
      else
        []
      end
    erb :'/stores/results'
  end

  get "/stores/:id" do
    find_store
    @favorited = Favorite.find_by_user_id_and_store_id(current_user.id, params[:id])
    erb :'/stores/show'
  end

  get "/stores/:id/edit" do
    invalid_resource?
    erb :'/stores/edit'
  end

  patch "/stores/:id" do
    invalid_resource?
    if Store.update(**update_store_params)
      redirect_to store_path(@store.id)
    else
      redirect_to store_path(@store.id)
    end
  end

  private

  def new_store_params
    attr_to_object(:store, :name, :street, :city, :state, :zip_code, :description, :website, :user_id)
  end

  def update_store_params
    attr_to_object(:name, :street, :city, :state, :zip_code, :description, :website)
  end

  def find_store
    @store = Store.find_by_id(params[:id]) 
    if @store.nil?
      redirect_to stores_path
    end
  end

  def invalid_resource?
    find_store
    if !current_user.id.equal?(@store.user_id)
      redirect_to store_path(@store.id)
    end
  end
end