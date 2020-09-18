integer = Random.new
50.times do
    Favorite.create(
        user_id: integer.rand(1..User.all.count),
        store_id: integer.rand(1..Store.all.count)
    )
end