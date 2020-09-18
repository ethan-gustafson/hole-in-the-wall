module UserHelper

    def is_current_user
        @is_current_user = current_user.id == params[:id].to_i
    end

    def current_user_reviews
        @reviews = Review.select("reviews.id, reviews.title, reviews.store_id AS store_id, reviews.created_at,stores.name AS store_name").joins(:store).where(
            reviews: {user_id: current_user.id}
        ).group("reviews.id, reviews.title, reviews.store_id, reviews.created_at, stores.name").order("reviews.created_at DESC").as_json
    end

    def current_user_favorites
        @favorites = Favorite.select("favorites.id, stores.name AS store_name, favorites.store_id AS store_id").joins(:store).where(
            favorites: {user_id: current_user.id}
        ).group("favorites.id, stores.name, favorites.store_id").order("favorites.id DESC").as_json
    end

    def current_user_stores
        @stores = Store.select("stores.id, stores.name, stores.created_at, stores.user_id").where(
            user_id: current_user.id
        ).order("stores.created_at DESC").as_json
    end

end