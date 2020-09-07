class Store < ActiveRecord::Base
    validates :name, :street, :city, :state, :zip_code, :description, :website, presence: true
    validates :user_id, presence: true, on: :create

    # Zip codes in the United States are exactly 5 digits in length
    validates :zip_code, length: { is: 5 }
    validates :state, length: { is: 2 }

    has_many :reviews
    has_many :favorites
    has_many :users, through: :favorites

end