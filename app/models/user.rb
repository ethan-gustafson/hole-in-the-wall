class User < ActiveRecord::Base
    has_secure_password

    has_many :reviews
    has_many :stores

    has_many :favorites
    has_many :favorited_stores, through: :favorites, source: :store

    before_validation :white_space

    validates :name, :email, :username, presence: true
    validates :password, presence: :true, on: :create
    validates :username, :email, uniqueness: true

    validates :username, length: { in: 2..64 }
    validates :email, length: { maximum: 254 }
    validates :password, length: { in: 2..128 }, on: :create

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