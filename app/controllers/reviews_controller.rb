class ReviewsController < ApplicationController

    post "/reviews" do # reviews#create == post "/reviews/:id"
        @review = Review.new(
            title: params[:review][:title],
            content: params[:review][:content],
            user_id: params[:review][:user_id],
            store_id: params[:review][:store_id]
            )
        if @review.save
            redirect "/stores/#{@review.store_id}"
        else
            redirect "/stores/#{@review.store_id}"
        end
    end

    get "/reviews/:id/edit" do
        find_review
        @store = Store.find_by_id(@review.store_id)
        erb :'/reviews/edit'
    end

    patch "/reviews/:id" do # reviews#update == patch "/reviews/:id"
        find_review

        if @review.user_id == current_user.id
            if @review.update(title: params[:review][:title], content: params[:review][:content])
                redirect "/stores/#{@review.store_id}"
            end
        else
            redirect "/stores/#{@review.store_id}"
        end
    end

    delete "/reviews/:id" do # reviews#destroy == delete "/reviews/:id"
        find_review
        store_id = @review.store_id

        if @review.user_id == current_user.id
            if @review.destroy 
                redirect "/stores/#{store_id}"
            end
        else
            redirect "/stores/#{store_id}"
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