class ReviewsController < ApplicationController

    get "/my-reviews" do
        redirect_if_not_logged_in?
        @reviews = current_user.reviews # shows all of this specific user's reviews
        erb :'/reviews/show_my_reviews' # Gives links to each review - Gives link to the Home Page
    end

    get "/my-reviews/:id" do
        redirect_if_not_logged_in?
        validreview? # if the user is logged in and their user_id is equal to the @user_review params id
        @user_review = Review.find_by_id(params[:id]) # finds the right review from post "/my-reviews" @review
        erb :'/reviews/show_individual_review' # Shows the correct review.
    end

    post "/my-reviews/:id" do
        @user_review = Review.new(params[:review])
        if @user_review.valid?
            @user_review.store_id = params[:id]
            @user_review.user_id = session[:user_id]
            @user_review.save
            redirect to "/my-reviews/#{@user_review.id}" # it is redirected to that specific review from @review
        else
            redirect to "/my-reviews"
        end
    end

    get "/my-reviews/:id/edit" do
        redirect_if_not_logged_in?  # they get the error message if it is not their review
        validreview? # if the user is logged in and their user_id is equal to the @user_review params id
        @user_review = Review.find_by_id(params[:id]) # keeps the same id from the right review
        erb :'/reviews/edit' # Allows the user to edit that review.
    end

    patch "/my-reviews/:id" do # patch request to the specific id
        @user_review = Review.find_by_id(params[:id]) # finds the right id to patch
        validreview? 

        if valid_params?
            @user_review.update(params[:review])
            redirect to "/my-reviews/#{@user_review.id}" # redirects to the specific id page
        else
            redirect to '/my-reviews/form'
        end
    end

    delete "/my-reviews/:id" do
        @user_review = Review.find_by_id(params[:id]) # will find the review by the params id

        validreview?  # if the current user is equal to the review user id
        @user_review.delete # then we will delete the post. 
        redirect '/my-reviews' # Redirected to their reviews.
    end

end