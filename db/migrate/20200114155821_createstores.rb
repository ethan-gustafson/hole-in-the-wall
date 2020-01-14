class Createstores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |c|
      c.string :name
      c.string :address
    end
  end
end
