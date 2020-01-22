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
    #     redirect_if_not_logged_in?
        
    #     erb :'/stores/my_stores'
    # end

    # post '/my-stores/:id' do 
    #     @store = Store.find_by_id(params[:id])
        
    #     redirect to "/my-stores"
    #     erb :'/stores/my_stores'
    # end

    # get '/my-stores/:id' do
    #     redirect_if_not_logged_in?
    #     @store = Store.find_by_id(params[:id])
    # end

end