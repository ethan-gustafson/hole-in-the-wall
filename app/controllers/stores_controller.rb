class StoresController < ApplicationController

    get '/stores' do
        if logged_in? # session works, users logged in will see 
        erb :'/stores/show_stores' # all of the stores.
        else
            redirect to '/hole-in-the-wall'
        end
    end

    get '/stores/:id' do
        if logged_in?
            
            else
                redirect to '/hole-in-the-wall'
            end
    end

    get '/my-stores' do
        if logged_in?
            
            else
                redirect to '/hole-in-the-wall'
            end
    end

    get '/my-stores/:id' do
        if logged_in?
            
            else
                redirect to '/hole-in-the-wall'
            end
    end

end