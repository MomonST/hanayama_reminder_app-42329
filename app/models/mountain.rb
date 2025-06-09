class Mountain < ApplicationRecord
  # アソシエーション
  has_many :flower_mountains, dependent: :destroy
  has_many :flowers, through: :flower_mountains
  has_many :posts, dependent: :destroy
  has_many :favorites, through: :flower_mountains
  
  # バリデーション
  validates :name, presence: true, uniqueness: true
  validates :region, presence: true, inclusion: { in: User::REGIONS }
  validates :difficulty_level, inclusion: { in: ["初心者", "中級者", "上級者"] }, allow_nil: true
  validates :elevation, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

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

  # 地理的な検索のためのスコープ
  scope :near, ->(coordinates, distance_km) {
    lat, lng = coordinates
    # 簡易的な距離計算（実際はもっと複雑な計算が必要）
    where("
      POW(latitude - ?, 2) + POW(longitude - ?, 2) < ?",
      lat, lng, (distance_km / 111.0)**2
    )
  }
  
  scope :by_region, ->(region) { where(region: region) }
  scope :by_elevation_range, ->(min, max) { 
    query = all
    query = query.where("elevation >= ?", min) if min.present?
    query = query.where("elevation <= ?", max) if max.present?
    query
  }
  
  scope :with_blooming_flowers, -> {
    joins(:flowers).merge(Flower.blooming_now).distinct
  }
  
  def has_blooming_flowers?
    flowers.any?(&:blooming_now?)
  end
  
  def max_difficulty_level
    flower_mountains.pluck(:difficulty_level).max_by { |d| 
      case d
      when '初心者' then 1
      when '中級者' then 2
      when '上級者' then 3
      else 0
      end
    } || '未設定'
  end

  def favorites_count
    flower_mountains.joins(:favorites).count
  end
end