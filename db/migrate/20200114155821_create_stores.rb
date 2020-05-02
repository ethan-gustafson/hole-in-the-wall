class CreateStores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |c|
      c.string :name
      c.string :address
      c.string :url
      c.string :description
      c.string :image
    end
  end
end
