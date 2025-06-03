FactoryBot.define do
  factory :notification do
    association :user
    association :flower_mountain
    days_before { 7 }
    notification_date { Date.current + 7.days }
    sent { false }

    # 送信済み通知
    factory :sent_notification do
      sent { true }
    end

    # 今日が通知日の通知
    factory :due_today_notification do
      notification_date { Date.current }
    end
  end
end
