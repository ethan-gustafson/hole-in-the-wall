class ReviewsController < ApplicationController

    get "/reviews" do
        current_user_reviews = []
        reviews_count = current_user.reviews.count

        if reviews_count > 10
            current_user_reviews_array[0..9].reverse.each do |e|
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
            {data: current_user_reviews, reviews_exceeded_count: true}.to_json
        else
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
    end

    get "/users/:id/reviews/:review_index_id" do
        redirect_outside?

        if params[:id].to_i != current_user.id
            redirect "/users/#{current_user.id}"
        end

        @current_page = params[:review_index_id].to_i
        @reviews_count = current_user.reviews.count

        end_i   = (@current_page * 20) - 1
        start_i = end_i - 19
        @reviews   = current_user.reviews[start_i..end_i]
        
        @reviews_count % 20 == 0 ? @last_page = (@reviews_count / 20) : @last_page = (@reviews_count / 20) + 1

        if @current_page > @last_page || @current_page < 1
            redirect "users/#{current_user.id}/favorites/1"
        end
        erb :'/reviews/index', locals: {
            title: "Reviews #{@current_page}", 
            css: false,
            banner: "/stylesheets/banners/loggedin.css",
            javascript: false
        }
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
            {message: "Success", username: current_user.username, review_id: @review.id}.to_json
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