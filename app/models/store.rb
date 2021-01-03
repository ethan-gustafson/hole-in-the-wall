class Store < ActiveRecord::Base
  belongs_to :user

  has_many :reviews
  has_many :favorites
  has_many :users, through: :favorites

  validates :name, :street, :city, :state, :zip_code, :description, :website, :user_id, presence: true, on: :create
  validates :name, :street, :city, :state, :zip_code, :description, :website, presence: true, on: :update
  validates :zip_code, length: { is: 5 }

  def self.last_five_most_popular
    select("stores.*, count(favorites.store_id) AS favorites_count")
      .joins(:favorites)
      .limit(5)
      .group("stores.id").
      order("favorites_count DESC")
  end

  def self.last_five_most_reviewed
    select("stores.*, count(reviews.store_id) AS reviews_count")
      .joins(:reviews)
      .limit(5)
      .group("stores.id").
      order("reviews_count DESC")
  end
end