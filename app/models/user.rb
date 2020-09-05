class User < ActiveRecord::Base
    has_secure_password
    
    before_validation :white_space

    validates :name, :email, :username, presence: true
    validates :password, presence: :true, on: :create
    validates :username, :email, uniqueness: true

    validates :username, length: { in: 2..64 }
    validates :email, length: { maximum: 254 }
    validates :password, length: { in: 2..128 }
    
    has_many :reviews
    has_many :favorites # These are the stores the user has liked
    has_many :stores, through: :favorites

    def white_space 
        self.attribute_names.each do |key|
            value = self.send(key)
            if value.respond_to?(:strip)
                if value.strip.length < value.length
                    errors.add(key.to_sym, "Can't have whitespace before or after #{key}")
                end
            end
        end
        self
    end
end