class Createusers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |c|
      c.string :name
      c.string :username
      c.string :email
      c.string :password_digest
      c.timestamps
    end
  end
end
