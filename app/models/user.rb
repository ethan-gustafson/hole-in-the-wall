class User < ActiveRecord::Base
    has_secure_password
    validates :name, presence: true
    validates_presence_of :username, :password
    validates :username, uniqueness: true
    validates :email, uniqueness: true
    
    has_many :reviews
end


# Note that even though our database has a column called password_digest, 
# we still access the attribute of password. 
# This is given to us by has_secure_password