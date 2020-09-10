class Favorite < ActiveRecord::Base
    belongs_to :store
    belongs_to :user

    validates :user_id, :store_id, presence: true, on: :create
    validates :store_id, uniqueness: true, on: :create
end