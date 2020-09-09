class ReviewsController < ApplicationController

    get "/reviews" do
        current_user_reviews = []
        current_user_reviews_array.reverse.each do |e|
            current_user_reviews << {id: e[0], title: e[1], content: e[2], user_id: e[3], store_id: e[4], created_at: Time.parse(e[5].to_s), updated_at: Time.parse(e[6].to_s), store: e[7]}
        end
        {data: current_user_reviews}.to_json
    end

    post "/reviews/:id" do # reviews#create == post "/reviews/:id"
        request_recieved = request.body.read
        parameters = JSON.parse(request_recieved, {symbolize_names: true})
        invalid = {reviews: "Sorry, we couldn't process that request"}.to_json

        @review = Review.new(
            title: parameters[:title],
            content: parameters[:content],
            user_id: parameters[:user_id],
            store_id: parameters[:store_id]
            )
        if @review.save
            {message: "Success", user: current_user.username}.to_json
        else
            invalid
        end
    end

    patch "/reviews/:id" do # reviews#update == patch "/reviews/:id"
        find_review 

        request_recieved = request.body.read
        parameters = JSON.parse(request_recieved, {symbolize_names: true})
        invalid = {reviews: "Sorry, we couldn't process that request"}.to_json

        if @review.update(review_params)
            {message: "Success"}.to_json
        else
            invalid
        end
    end

    delete "/reviews/:id" do # reviews#destroy == delete "/reviews/:id"
        find_review

        request_recieved = request.body.read
        parameters = JSON.parse(request_recieved, {symbolize_names: true})
        invalid = {reviews: "Sorry, we couldn't process that request"}.to_json

        if @review.destroy 
            {message: "Success"}.to_json
        else
            {message: "Failure"}.to_json
        end
    end

    private

    def find_review
        @review = Review.find_by_id(params[:id]) 
    end

    def current_user_reviews_array # returns an array with the [review.id, review.title, review.content, review.user_id, review.store_id, store.name]
        Review.includes(
            :store
        ).where(
            reviews: {user_id: 3}).pluck(
                "reviews.id, 
                reviews.title, 
                reviews.content, 
                reviews.user_id, 
                reviews.store_id, 
                reviews.created_at,
                reviews.updated_at,
                stores.name"
            )
    end



end