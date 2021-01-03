module ReviewsHelper
  def edit_review_path(id)
    "/reviews/#{id}/edit"
  end
  
  def find_review
    @review = Review.find_by_id(params[:id]) 
  end

  def review_belongs_to_user
    @review.user_id.equal?(current_user.id)
  end
end