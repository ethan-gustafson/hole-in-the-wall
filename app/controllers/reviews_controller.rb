class ReviewsController < ApplicationController

    post "/reviews" do # reviews#create == post "/reviews/:id"
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
            {message: "Success"}.to_json
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

end