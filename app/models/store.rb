class Store < ActiveRecord::Base
    has_many :reviews
    has_many :user_stores
    has_many :users, through: :user_stores
end