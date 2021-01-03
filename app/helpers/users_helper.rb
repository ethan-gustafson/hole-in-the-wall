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

  def current_user 
    @current_user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def is_current_user
    current_user.id.equal?(params[:id].to_i)
  end

  def logged_in? 
    !!current_user
  end

  def redirect_current_user_to_root?
    redirect_to root_path if logged_in? 
  end

  def redirect_non_user_to_login?
    redirect_to login_path if !logged_in?
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
  
  def listed_users_by_accounts_page(current_page) # FIX NEEDED
    end_index          = (current_page * 20) - 1
    start_index        = end_index - 19
    @users_info = users_count_and_range(start_index, end_index)
    calculate_last_page(current_page)
  end

  def calculate_last_page(current)
    @last_page = 
    if @users_info[:user_count] % 20 == 0  
      @users_info[:user_count] / 20
    else 
      (@users_info[:user_count] / 20) + 1
    end
  end

  def users_count_and_range(start_index, end_index)
    { user_count: User.count,  user_range: User.all[start_index..end_index] }
  end
end