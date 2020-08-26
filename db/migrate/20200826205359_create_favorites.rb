class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |c|
      c.integer :user_id
      c.integer :store_id
    end
  end
end
