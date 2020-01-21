class StoresController < ApplicationController

    get '/stores' do
        redirect_if_not_logged_in? # session works, users logged in will see 
        erb :'/stores/show_stores' # all of the stores.
    end

    get '/stores/:id' do
    redirect_if_not_logged_in?
    @store = Store.find_by_id(params[:id])
    erb :'/stores/show_individual_store'
    end

    # get '/my-stores' do
    # @my_stores = current_user.stores
    #     if logged_in?
    #         erb :'/stores/my_stores'
    #     else
    #         redirect to '/hole-in-the-wall'
    #     end
    # end

    # post '/my-stores' do
        # needs a UserStore.new - UserStore model
    # end

    # get '/my-stores/:id' do
    # @favorited = Store.find_by_id(params[:id])
    #     if logged_in?
    #         erb :'/stores/show_individual_store'
    #     else
    #         redirect to '/hole-in-the-wall'
    #     end
    # end

end