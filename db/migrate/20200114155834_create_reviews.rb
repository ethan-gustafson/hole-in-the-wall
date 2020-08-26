class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |c|
      c.string :title
      c.string :content
      c.integer :user_id
      c.integer :store_id
      c.timestamps
    end
  end
end
