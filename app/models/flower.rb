class Flower < ApplicationRecord
  # アソシエーション
  has_many :flower_mountains, dependent: :destroy
  has_many :mountains, through: :flower_mountains
  
  # バリデーション
  validates :name, presence: true
  validates :bloom_start_month, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }, allow_nil: true
  validates :bloom_end_month, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }, allow_nil: true
  
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
end