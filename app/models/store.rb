class Store < ActiveRecord::Base
    validates :name, :address, :description, :website, presence: true

    has_many :reviews
    has_many :favorites
    has_many :users, through: :favorites
end