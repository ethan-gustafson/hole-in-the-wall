class ReviewsController < ApplicationController

    post "/reviews" do
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

    patch "/reviews/:id" do
        find_review

        if user_is_review_owner
            if @review.update(title: params[:review][:title], content: params[:review][:content])
                redirect "/stores/#{@review.store_id}"
            end
        else
            redirect "/stores/#{@review.store_id}"
        end
    end

    delete "/reviews/:id" do 
        find_review
        store_id = @review.store_id

        if user_is_review_owner
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

    def user_is_review_owner
        @review.user_id == current_user.id
    end

end