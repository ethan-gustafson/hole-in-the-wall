class AddUsersToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :user_id, :integer
  end
end
