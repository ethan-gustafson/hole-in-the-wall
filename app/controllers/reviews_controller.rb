class ReviewsController < ApplicationController
  post "/reviews" do
    @review = new_strong_params(params, Review, :title, :content, :user_id, :store_id)
    redirect_to store_path(@review.store_id) if @review.save || !@review.save
  end

  get "/reviews/:id/edit" do
    redirect_logged_out_user_to_login?
    set_review
    @store = Store.find_by_id(@review.store_id)
    erb :'/reviews/edit'
  end

  patch "/reviews/:id" do
    set_review
    if review_belongs_to_user && 
       update_strong_params(params, Review, @review, :title, :content)
      redirect_to store_path(@review.store_id)
    else
      redirect_to store_path(@review.store_id)
    end
  end

  delete "/reviews/:id" do 
    set_review
    store_id = @review.store_id
    if review_belongs_to_user && @review.destroy 
      redirect_to store_path(store_id)
    else
      redirect_to store_path(store_id)
    end
  end
end