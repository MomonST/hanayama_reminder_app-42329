class FlowerMountain < ApplicationRecord
  # アソシエーション
  belongs_to :flower
  belongs_to :mountain
  has_many :favorites, dependent: :destroy
  
  # バリデーション
  validates :flower_id, uniqueness: { scope: :mountain_id }
  validates :peak_month, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }, allow_nil: true
  
  # 現在見頃の花山スポットを取得
  def self.currently_in_peak
    current_month = Date.today.month
    where(peak_month: current_month)
  end
  
  # 指定月に見頃の花山スポットを取得
  def self.peak_in_month(month)
    where(peak_month: month)
  end

  # 見頃の季節を返す
  def peak_season
    peak_month.present? ? "#{peak_month}月" : "情報なし"
  end

  # 花が見頃かどうか
  def blooming_now?
    flower.blooming_now?
  end

  # 山の難易度を返す
  def difficulty_level
    mountain.difficulty_level
  end
  
  # 見頃までの残り日数を計算
  def days_until_peak
    return nil unless peak_month
    
    today = Date.today
    peak_date = Date.new(today.year, peak_month, 15) # 月の中旬を見頃と仮定
    
    # 既に今年の見頃が過ぎていれば来年の見頃までの日数を計算
    if peak_date < today
      peak_date = Date.new(today.year + 1, peak_month, 15)
    end
    
    (peak_date - today).to_i
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "flower_id", "mountain_id", "peak_month", "bloom_info", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    [] # flower や mountain に絞りたければ ["flower", "mountain"]
  end
end