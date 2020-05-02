class CreateUserStores < ActiveRecord::Migration[5.2]
  def change
    create_table :user_stores do |c|
      c.integer :user_id
      c.integer :store_id
    end
  end
end
