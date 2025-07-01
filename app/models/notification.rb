class Notification < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :flower
  belongs_to :mountain
  
  # バリデーション
  validates :days_before, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :user_id, presence: true, uniqueness: { scope: [:flower_id, :mountain_id], message: "既にこの花山スポットの通知が設定されています" }
  validates :notification_date, presence: true
  validates :notification_type, presence: true, inclusion: { in: %w(flower_blooming reminder like comment system) } 

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

  def mark_as_sent!
    update(sent: true)
  end

  def title
    "#{flower.name} 見頃通知"
  end

  def message
    "#{mountain.name}で#{flower.name}が見頃です！通知は#{days_before}日前です。"
  end

  def estimated_peak_month
    return nil unless flower.present?

    today = Date.today
    current_year = today.year

    # 見頃の中央値を仮定（月の中央値＝開始と終了の間）
    if flower.bloom_start_month && flower.bloom_end_month
      average_month = ((flower.bloom_start_month + flower.bloom_end_month) / 2.0).round
      return average_month
    end

    nil
  end

  # 見頃までの日数
  def days_until_peak
    return nil unless estimated_peak_month

    today = Date.today
    peak_date = Date.new(today.year, estimated_peak_month, 15)
    peak_date += 1.year if peak_date < today
    (peak_date - today).to_i
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id post_id action checked created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user flower_mountain]
  end

  private
  
  # 通知日を計算（見頃の日付から指定日数前）
  def calculate_notification_date
    return unless flower.present? && mountain.present? && days_before.present?

    # FlowerMountain に依存せず flower 側の bloom_start_month を使う
    if flower.bloom_start_month.present?
      peak_month = flower.bloom_start_month
      peak_date = Date.new(Date.today.year, peak_month, 15)  # 月の中旬を見頃と仮定
      peak_date += 1.year if peak_date < Date.today
      # 既に今年の見頃が過ぎていれば来年の見頃を対象にする
      self.notification_date = peak_date - days_before.days
    else
      # fallback：デフォルトや通知日未設定
      self.notification_date = nil
    end
  end
end