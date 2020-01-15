class User < ActiveRecord::Base
    has_secure_password
    has_many :reviews
    has_many :stores, through: :user_stores
end


# Note that even though our database has a column called password_digest, 
# we still access the attribute of password. 
# This is given to us by has_secure_password