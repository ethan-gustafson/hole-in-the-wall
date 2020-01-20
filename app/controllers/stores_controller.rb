class StoresController < ApplicationController

    get '/stores' do
        if logged_in? # session works, users logged in will see 
        erb :'/stores/show_stores' # all of the stores.
        else
            redirect to '/hole-in-the-wall'
        end
    end

    get '/stores/:id' do
    @store = Store.find_by_id(params[:id])
        if logged_in?
            erb :'/stores/show_individual_store'
        else
            redirect to '/hole-in-the-wall'
        end
    end

    post "/stores/:id" do
        @review = Review.new(:title => params[:review][:title], :content => params[:review][:content])
        if @review.valid?
            @review.save
            @review.user_id = current_user.id
        redirect to "/my-reviews/#{@review.id}" # it is redirected to that specific review from @review
        else
            redirect to "/my-reviews"
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