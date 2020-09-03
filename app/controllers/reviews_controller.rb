class ReviewsController < ApplicationController

    namespace "/reviews" do

        post "/:id" do # reviews#create == post "/reviews/:id"
            @user_review = Review.new(params[:review])
            if @user_review.valid?
                @user_review.store_id = params[:store_id]
                @user_review.user_id = session[:user_id]
                @user_review.save
                redirect "/reviews/#{@user_review.id}" # it is redirected to that specific review from @review
            else
                redirect "/reviews"
            end
        end

        patch "/:id" do # reviews#update == patch "/reviews/:id"
            @user_review = Review.find_by_id(params[:id]) # finds the right id to patch
            validreview? 
    
            if valid_params?
                @user_review.update(params[:review])
                redirect to "/reviews/#{@user_review.id}"
            else
                redirect to '/reviews'
            end
        end
    
        delete "/:id" do # reviews#destroy == delete "/reviews/:id"
            @user_review = Review.find_by_id(params[:id]) 
    
            validreview?  # if the current user is equal to the review user id
            @user_review.destroy # then we will delete the post. 
            redirect "/users/#{current_user.id}" # Redirected to their account.
        end
        
    end

end