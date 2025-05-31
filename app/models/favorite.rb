class Favorite < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :flower_mountain
  
  # バリデーション
  validates :user_id, uniqueness: { scope: :flower_mountain_id, message: "既にお気に入りに追加されています" }
end