class Flower < ApplicationRecord
  # アソシエーション
  has_many :flower_mountains, dependent: :destroy
  has_many :mountains, through: :flower_mountains
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :favorites, through: :flower_mountains
  has_many :notifications, dependent: :destroy
  
  # バリデーション
  validates :name, presence: true, uniqueness: true
  validates :bloom_start_month, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :bloom_end_month, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :description, presence: true

  # スコープ追加
  scope :blooming_now, -> { 
    current_month = Date.current.month
    where("bloom_start_month <= ? AND bloom_end_month >= ?", current_month, current_month)
  }
  
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { 
    left_joins(:likes)
      .group(:id)
      .order('COUNT(likes.id) DESC') 
  }

  def blooming_now?
    current_month = Date.current.month
    bloom_start_month <= current_month && bloom_end_month >= current_month
  end

  def blooming_season
    if bloom_start_month == bloom_end_month
      "#{bloom_start_month}月"
    else
      "#{bloom_start_month}月〜#{bloom_end_month}月"
    end
  end

  # 画像アップロード（CarrierWave使用）
  mount_uploader :image_url, FlowerImageUploader if defined?(FlowerImageUploader)
  
  # 現在開花中の花を取得
  def self.currently_blooming
    current_month = Date.today.month
    where("bloom_start_month <= ? AND bloom_end_month >= ?", current_month, current_month)
  end
  
  # 指定月に開花する花を取得
  def self.blooming_in_month(month)
    where("bloom_start_month <= ? AND bloom_end_month >= ?", month, month)
  end

  def likes_count
    flower_mountains.includes(:posts).sum { |fm| fm.posts.sum(:likes_count) }
  end

  def favorites_count
    flower_mountains.joins(:favorites).count
  end

  def self.ransackable_associations(auth_object = nil)
    ["flower_mountains", "mountains", "posts", "favorites", "likes", "liked_users"]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name scientific_name bloom_start_month bloom_end_month description image_url created_at updated_at]
  end
end