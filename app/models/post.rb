class Post < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :flower_mountain
  belongs_to :mountain, optional: true
  has_many :post_likes, dependent: :destroy
  has_many :liked_users, through: :post_likes, source: :user
  
  # バリデーション
  validates :content, presence: true, length: { maximum: 500 }
  validates :image_url, presence: true
  validate :flower_or_mountain_present

  # 画像アップロード（CarrierWave使用）
  mount_uploader :image_url, PostImageUploader if defined?(PostImageUploader)
  
  # いいねの数を更新
  def update_likes_count
    update_column(:likes_count, post_likes.count)
  end
  
  # スコープ
  scope :recent, -> { order(created_at: :desc) }      # 最新順に投稿を取得
  scope :oldest, -> { order(created_at: :asc) }

  # 人気順に投稿を取得
  scope :popular, -> {
    left_joins(:post_likes)
      .group(:id)
      .order('COUNT(post_likes.id) DESC') 
  }

  scope :by_flower, ->(flower_id) { where(flower_id: flower_id) }
  scope :by_mountain, ->(mountain_id) { where(mountain_id: mountain_id) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }

  def likes_count
    post_likes.count
  end
  
  # 画像アップロード（CarrierWaveを使用する場合）
  # mount_uploader :image_url, ImageUploader

  private

  def flower_or_mountain_present
    if flower_mountain.nil? || (flower_mountain.flower.nil? && flower_mountain.mountain.nil?)
      errors.add(:base, "花または山のどちらかを選択してください")
    end
  end
end