integer = Random.new
50.times do
    Favorite.create(
        user_id: integer.rand(User.all.count),
        store_id: integer.rand(Store.all.count)
    )
end