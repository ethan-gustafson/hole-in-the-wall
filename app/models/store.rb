class Store < ActiveRecord::Base
    belongs_to :user_stores
    has_many :reviews
    has_many :user_stores
    has_many :users, through: :user_stores
end