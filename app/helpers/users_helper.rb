module UsersHelper

  def users_path(id) # Index
    "/users/accounts/#{id}"
  end

  def new_user_path # New
    "/users/new"
  end

  def user_path(id) # Show
    "/users/#{id}"
  end

  def is_current_user
    current_user.id.equal?(params[:id].to_i)
  end

  def current_user_reviews
    Review
      .joins(:store)
      .select("reviews.*, stores.name AS store_name")
      .where(reviews: { user_id: current_user.id } )
      .group("reviews.id, stores.name").
      order("reviews.created_at DESC")
  end

  def current_user_favorites
    Favorite
      .joins(:store)
      .select("favorites.*, stores.name AS store_name")
      .where(favorites: { user_id: current_user.id } )
      .group("favorites.id, stores.name").
      order("favorites.id DESC")
  end

  def current_user_stores
    Store.where(user_id: current_user.id).order(created_at: :desc)
  end

  def listed_users_by_accounts_page(current_page)
    @user_count = User.count
    end_i   = (current_page * 20) - 1
    start_i = end_i - 19
    @users  = User.all[start_i..end_i]
    @last_page = 
    if @user_count % 20 == 0  
      @user_count / 20
    else 
      (@user_count / 20) + 1
    end
  end
end