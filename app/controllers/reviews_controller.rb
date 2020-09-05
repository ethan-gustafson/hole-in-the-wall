class ReviewsController < ApplicationController

    post "/reviews/:id" do # reviews#create == post "/reviews/:id"
        if @review = Review.create(review_params)
            redirect "/stores/#{@review.store_id}"
        else
            redirect "/stores"
        end
    end

    patch "/reviews/:id" do # reviews#update == patch "/reviews/:id"
        find_review 

        if @review.update(review_params)
            redirect "/stores/#{@review.store_id}"
        else
            redirect '/stores'
        end
    end

    delete "/reviews/:id" do # reviews#destroy == delete "/reviews/:id"
        find_review

        @review.destroy 
        redirect "/users/#{current_user.id}"
    end

    private

    def review_params
        key  = require_param(:review)
    
        hash = permit_params(
            key,
            :title, 
            :content
        )
        hash[:review].store(:user_id, params[:review][:user_id]) if params[:review][:user_id]
        hash[:review].store(:store_id, params[:review][:store_id]) if params[:review][:store_id]
        hash[:review]
    end

    def find_review
        @review = Review.find_by_id(params[:id]) 
    end

end