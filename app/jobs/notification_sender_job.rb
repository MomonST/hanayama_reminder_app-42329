class NotificationSenderJob < ApplicationJob
  queue_as :default

  def perform
    # 今日送信すべき通知を取得
    notifications = Notification.to_be_sent_today.includes(flower_mountain: [:flower, :mountain], user: [])
    
    notifications.each do |notification|
      # メール送信
      FlowerMailer.bloom_reminder(
        notification.user,
        notification.flower_mountain.flower,
        notification.flower_mountain.mountain
      ).deliver_now
      
      # 送信済みフラグを更新
      notification.update(sent: true)
    end
  end
end