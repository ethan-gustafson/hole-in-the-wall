class ReviewsController < ApplicationController

    before {redirect_if_not_logged_in?}

    get ("/my-reviews") {
        @reviews = current_user.reviews # shows all of this specific user's reviews
        erb :'/reviews/show_my_reviews' # Gives links to each review - Gives link to the Home Page
    }

    get ("/my-reviews/:id") {
        validreview? # if the user is logged in and their user_id is equal to the @user_review params id
        @user_review = Review.find_by_id(params[:id]) # finds the right review from post "/my-reviews" @review
        if @user_review
            erb :'/reviews/show' # Shows the correct review.
        else
            redirect to "/my-reviews"
        end
    }

    post ("/my-reviews/:id") {
        @user_review = Review.new(params[:review])
        if @user_review.valid?
            @user_review.store_id = params[:store_id]
            @user_review.user_id = session[:user_id]
            @user_review.save
            redirect to "/my-reviews/#{@user_review.id}" # it is redirected to that specific review from @review
        else
            redirect to "/my-reviews"
        end
    }

    get ("/my-reviews/:id/edit") {
        validreview? # if the user is logged in and their user_id is equal to the @user_review params id
        @user_review = Review.find_by_id(params[:id]) # keeps the same id from the right review
        erb :'/reviews/edit' # Allows the user to edit that review.
    }

    patch ("/my-reviews/:id") { # patch request to the specific id
        @user_review = Review.find_by_id(params[:id]) # finds the right id to patch
        validreview? 

        if valid_params?
            @user_review.update(params[:review])
            redirect to "/my-reviews/#{@user_review.id}" # redirects to the specific id page
        else
            redirect to '/my-reviews/form'
        end
    }

    delete ("/my-reviews/:id") {
        @user_review = Review.find_by_id(params[:id]) # will find the review by the params id

        validreview?  # if the current user is equal to the review user id
        @user_review.destroy # then we will delete the post. 
        redirect '/my-reviews' # Redirected to their reviews.
    }

end