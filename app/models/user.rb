class User < ActiveRecord::Base
    has_secure_password
    validates :name, :username, :password, presence: true
    validates :username, :email, uniqueness: true
    
    has_many :reviews
    has_many :user_stores # These are the stores the user has liked
    has_many :stores, through: :user_stores
end