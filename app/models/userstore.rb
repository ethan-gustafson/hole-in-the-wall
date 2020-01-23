class UserStore < ActiveRecord::Base
    belongs_to :store
    belongs_to :user
    validates :store_id, uniqueness: true
end