class Favorite < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :flower_mountain
  
  # バリデーション
  validates :user_id, uniqueness: { scope: :flower_mountain_id, message: "既にお気に入りに追加されています" }

  # スコープ
  scope :recent, -> { order(created_at: :desc) }
  scope :by_flower, ->(flower_id) { 
    joins(:flower_mountain).where(flower_mountains: { flower_id: flower_id }) 
  }
  scope :by_mountain, ->(mountain_id) { 
    joins(:flower_mountain).where(flower_mountains: { mountain_id: mountain_id }) 
  }

  def flower
    flower_mountain.flower
  end

  def mountain
    flower_mountain.mountain
  end

  # ActiveAdmin用: 検索許可するカラム
  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id flower_mountain_id created_at updated_at]
  end

  # ActiveAdmin用: 関連（今回は検索対象にしないが、必要なら追加可）
  def self.ransackable_associations(auth_object = nil)
    %w[user flower_mountain]
  end
end