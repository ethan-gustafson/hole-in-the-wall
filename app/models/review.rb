class Review < ActiveRecord::Base
    validates :title, presence: true
    validates :title, uniqueness: true
    validates :content, presence: true
    belongs_to :user
    belongs_to :store
end