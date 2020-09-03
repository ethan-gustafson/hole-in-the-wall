class StoresController < ApplicationController

    before { redirect_if_not_logged_in? }

    namespace "/stores" do

        get "/" do # stores#index == get "/stores"
            loggedin_banner
            erb :'/stores/index'
        end

        get "/new" do # stores#new == get "/stores/new"
            loggedin_banner_dynamic
            erb :'/stores/new'
        end
    
        get "/:id" do # stores#show == get "/stores/:id"
            loggedin_banner_dynamic
            api_k
            
            @store = Store.find_by_id(params[:id])
            erb :'/stores/show'
        end
    
        post "/" do # stores#create == post "/stores"
            @store = Store.new(params)
            if @store.save
                redirect "/stores/#{@store.id}"
            end
        end

        get "/:id/edit" do # stores#edit == get "/stores/:id/edit"
            loggedin_banner_dynamic
            api_k
            
            @store = Store.find_by_id(params[:id])
            erb :'/stores/edit'
        end

        patch "/:id" do # stores#update == patch "/stores/:id"
            @store = Store.find_by_id(params[:id]) 
            if @store.update(params)
                redirect "/stores/#{@store.id}"
            else
                redirect "/stores/#{@store.id}"
            end
        end
        
    end

    # get "/search-stores" do
    #     loggedin_banner
        
    # end

end