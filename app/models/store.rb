class Store < ActiveRecord::Base
    belongs_to :user
    
    has_many :reviews
    has_many :favorites
    has_many :users, through: :favorites
    
    validates :name, :street, :city, :state, :zip_code, :description, :website, :user_id, presence: true

    # Zip codes in the United States are exactly 5 digits in length
    validates :zip_code, length: { is: 5 }

end