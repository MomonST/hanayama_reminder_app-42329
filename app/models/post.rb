class Post < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :flower_mountain
  has_many :likes, dependent: :destroy
  
  # バリデーション
  validates :content, presence: true, length: { maximum: 500 }
  
  # 画像アップロード（CarrierWave使用）
  mount_uploader :image_url, PostImageUploader if defined?(PostImageUploader)
  
  # いいねの数を更新
  def update_likes_count
    update_column(:likes_count, likes.count)
  end
  
  # 人気順に投稿を取得
  scope :popular, -> { order(likes_count: :desc) }
  
  # 最新順に投稿を取得
  scope :latest, -> { order(created_at: :desc) }
end