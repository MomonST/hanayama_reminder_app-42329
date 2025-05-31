class Mountain < ApplicationRecord
  # アソシエーション
  has_many :flower_mountains, dependent: :destroy
  has_many :flowers, through: :flower_mountains
  
  # バリデーション
  validates :name, presence: true
  validates :region, inclusion: { in: User::REGIONS }, allow_nil: true
  validates :difficulty_level, inclusion: { in: ["初心者", "中級者", "上級者"] }, allow_nil: true
  
  # 画像アップロード（CarrierWave使用）
  mount_uploader :image_url, MountainImageUploader if defined?(MountainImageUploader)
  
  # 地域ごとの山を取得
  scope :in_region, ->(region) { where(region: region) }
  
  # 難易度ごとの山を取得
  scope :by_difficulty, ->(level) { where(difficulty_level: level) }
  
  # 緯度経度から地図表示用のJSON生成
  def to_map_json
    {
      id: id,
      name: name,
      lat: latitude,
      lng: longitude,
      difficulty: difficulty_level,
      image: image_url.url || "/assets/default_mountain.jpg"
    }
  end
end