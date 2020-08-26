class User < ActiveRecord::Base
    has_secure_password
    validates :name, :email, :username, presence: true
    validates_presence_of :password, :on => :create
    validates :username, :email, uniqueness: true
    
    has_many :reviews
    has_many :favorites # These are the stores the user has liked
    has_many :stores, through: :favorites
end