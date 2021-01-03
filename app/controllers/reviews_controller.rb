class ReviewsController < ApplicationController
  post "/reviews" do
    @review = Review.new(**new_review_params)
    redirect_to store_path(@review.store_id) if @review.save || !@review.save
  end

  get "/reviews/:id/edit" do
    redirect_non_user_to_login?
    find_review
    @store = Store.find_by_id(@review.store_id)
    erb :'/reviews/edit'
  end

  patch "/reviews/:id" do
    find_review
    if review_belongs_to_user && Review.update(**update_review_params)
      redirect_to store_path(@review.store_id)
    else
      redirect_to store_path(@review.store_id)
    end
  end

  delete "/reviews/:id" do 
    find_review
    store_id = @review.store_id
    if review_belongs_to_user && @review.destroy 
      redirect_to store_path(store_id)
    else
      redirect_to store_path(store_id)
    end
  end

  private

  def new_review_params
    attr_to_object(:review, :title, :content, :user_id, :store_id)
  end

  def update_review_params
    attr_to_object(:review, :title, :content)
  end
end