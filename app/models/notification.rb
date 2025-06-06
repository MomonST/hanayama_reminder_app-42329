class Notification < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :flower_mountain
  
  # バリデーション
  # validates :title, presence: true
  # validates :message, presence: true
  validates :days_before, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :user_id, presence: true, uniqueness: { scope: :flower_mountain_id, message: "既にこの花山スポットの通知が設定されています" }
  validates :notification_date, presence: true
  validates :flower_mountain_id, presence: true

  # 通知日の自動計算
  before_validation :calculate_notification_date
  
  # 今日送信すべき通知を取得
  scope :to_be_sent_today, -> { where(notification_date: Date.today, sent: false) }
  
  # スコープ
  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :unsent, -> { where(sent: false) }
  scope :sent, -> { where(sent: true) }
  scope :due_today, -> { where(notification_date: Date.current) }

  # 通知タイプに応じたアイコンを返す
  def icon_type
    case notification_type
    when 'flower_blooming'
      'flower1'
    when 'reminder'
      'bell'
    when 'like'
      'heart'
    when 'comment'
      'chat'
    when 'system'
      'info-circle'
    else
      'bell'
    end
  end

  # 通知タイプに応じた色を返す
  def color
    case notification_type
    when 'flower_blooming'
      'success'
    when 'reminder'
      'primary'
    when 'like'
      'danger'
    when 'comment'
      'info'
    when 'system'
      'warning'
    else
      'secondary'
    end
  end

  def flower
    flower_mountain.flower
  end

  def mountain
    flower_mountain.mountain
  end

  def mark_as_sent!
    update(sent: true)
  end

  def title
    "#{flower_mountain.flower.name} 見頃通知"
  end

  def message
    "#{flower_mountain.mountain.name}で#{flower_mountain.flower.name}が見頃です！通知は#{days_before}日前です。"
  end


  private
  
  # 通知日を計算（見頃の日付から指定日数前）
  def calculate_notification_date
    return unless flower_mountain.present? && days_before.present?

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