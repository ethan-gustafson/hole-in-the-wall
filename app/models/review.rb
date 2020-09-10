class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :store
    
    validates :title, :content, presence: true
    validates :user_id, :store_id, presence: true, on: :create
    validates :title, uniqueness: true
end