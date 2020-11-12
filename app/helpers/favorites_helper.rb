module FavoritesHelper
  def favorite_path(id)
    "/favorites/#{id}"
  end

  def delete_favorite_path(id)
    "/favorites/#{id}/delete"
  end
end