class Createstores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |c|
      c.string :name
      c.string :address
      c.string :url
      c.string :description
    end
  end
end
