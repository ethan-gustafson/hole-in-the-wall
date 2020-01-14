class User < ActiveRecord::Base
    has_secure_password
end

# Note that even though our database has a column called password_digest, 
# we still access the attribute of password. 
# This is given to us by has_secure_password