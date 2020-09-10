class Review < ActiveRecord::Base
    validates :title, :content, presence: true
    validates :user_id, :store_id, presence: true, on: :create
    validates :title, uniqueness: true
    
    belongs_to :user
    belongs_to :store
end