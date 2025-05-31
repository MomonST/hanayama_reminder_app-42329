class Notification < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :flower_mountain
  
  # バリデーション
  validates :days_before, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :user_id, uniqueness: { scope: :flower_mountain_id, message: "既にこの花山スポットの通知が設定されています" }
  
  # 通知日の自動計算
  before_save :calculate_notification_date
  
  # 今日送信すべき通知を取得
  scope :to_be_sent_today, -> { where(notification_date: Date.today, sent: false) }
  
  private
  
  # 通知日を計算（見頃の日付から指定日数前）
  def calculate_notification_date
    peak_month = flower_mountain.peak_month
    return unless peak_month
    
    today = Date.today
    peak_date = Date.new(today.year, peak_month, 15) # 月の中旬を見頃と仮定
    
    # 既に今年の見頃が過ぎていれば来年の見頃を対象にする
    if peak_date < today
      peak_date = Date.new(today.year + 1, peak_month, 15)
    end
    
    self.notification_date = peak_date - days_before.days
  end
end