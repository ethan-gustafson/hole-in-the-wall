class ReviewsController < ApplicationController

    get "/reviews" do
        current_user_reviews = []
        current_user_reviews_array.reverse.each do |e|
            current_user_reviews << {
                id: e[0], 
                title: e[1], 
                content: e[2], 
                user_id: e[3], 
                store_id: e[4], 
                created_at: Time.parse(e[5].to_s), 
                updated_at: Time.parse(e[6].to_s), 
                store: e[7]
            }
        end
        {data: current_user_reviews}.to_json
    end

    post "/reviews" do # reviews#create == post "/reviews/:id"
        parameters = JSON.parse(request_parameters, {symbolize_names: true})

        @review = Review.new(
            title: parameters[:title],
            content: parameters[:content],
            user_id: parameters[:user_id],
            store_id: parameters[:store_id]
            )
        if @review.save
            {message: "Success", user: current_user.username}.to_json
        else
            failure
        end
    end

    patch "/reviews/:id" do # reviews#update == patch "/reviews/:id"
        parameters = JSON.parse(request_parameters, {symbolize_names: true})

        review = Review.find_by_id(parameters[:id])

        if review.user_id == current_user.id
            if review.update(title: parameters[:title], content: parameters[:content])
                {message: "Success", user_id: current_user.id, username: current_user.username}.to_json
            end
        else
            failure
        end
    end

    delete "/reviews/:id" do # reviews#destroy == delete "/reviews/:id"
        parameters = JSON.parse(request_parameters, {symbolize_names: true})

        review = Review.find_by_id(parameters[:id])

        if review.user_id == current_user.id
            if review.destroy 
                success
            end
        else
            failure
        end
    end

    private

    def request_parameters
        request_recieved = request.body.read
    end

    def find_review
        @review = Review.find_by_id(params[:id]) 
    end

    def success
        {message: "Success"}.to_json
    end

    def failure
        {message: "Failure"}.to_json
    end

    def current_user_reviews_array # returns an array with the [review.id, review.title, review.content, review.user_id, review.store_id, store.name]
        Review.includes(
            :store
        ).where(
            reviews: {user_id: current_user.id}).pluck(
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