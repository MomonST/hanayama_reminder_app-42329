require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'バリデーション' do
    it 'ファクトリが有効であること' do
      expect(FactoryBot.build(:notification)).to be_valid
    end

    it 'days_beforeが必須であること' do
      notification = FactoryBot.build(:notification, days_before: nil)
      expect(notification).not_to be_valid
      expect(notification.errors[:days_before]).to include("を入力してください")
    end

    it 'days_beforeが正の数であること' do
      notification = FactoryBot.build(:notification, days_before: 0)
      expect(notification).not_to be_valid

      notification = FactoryBot.build(:notification, days_before: -1)
      expect(notification).not_to be_valid

      notification = FactoryBot.build(:notification, days_before: 7)
      expect(notification).to be_valid
    end

    it 'notification_dateが必須であること' do
      notification = FactoryBot.build(:notification, notification_date: nil)
      expect(notification).not_to be_valid
      expect(notification.errors[:notification_date]).to include("を入力してください")
    end
  end

  describe 'アソシエーション' do
    it 'userとの関連があること' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'flower_mountainとの関連があること' do
      association = described_class.reflect_on_association(:flower_mountain)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'スコープ' do
    let!(:sent_notification) { FactoryBot.create(:sent_notification) }
    let!(:unsent_notification) { FactoryBot.create(:notification, sent: false) }
    # ここだけ書き換え
    let!(:due_notification) do
      n = FactoryBot.create(:notification)
      n.update_column(:notification_date, Date.current)
      n
    end
    let!(:n1) { FactoryBot.create(:notification, created_at: 1.day.ago) }
    let!(:n2) { FactoryBot.create(:notification, created_at: 1.hour.ago) }
    let!(:older) { FactoryBot.create(:notification, created_at: 1.day.ago) }
    let!(:newer) { FactoryBot.create(:notification, created_at: Time.current) }

    describe '.unsent' do
      it '未送信の通知のみ返すこと' do
        expect(Notification.unsent).to include(unsent_notification)
        expect(Notification.unsent).not_to include(sent_notification)
      end
    end

    describe '.sent' do
      it '送信済みの通知のみ返すこと' do
        expect(Notification.sent).to include(sent_notification)
        expect(Notification.sent).not_to include(unsent_notification)
      end
    end

    describe '.due_today' do
      it '今日が通知日の通知を返すこと' do
        expect(Notification.due_today).to include(due_notification)
      end
    end

    describe '.recent' do
      it '作成日時の降順で返すこと' do
        expect(Notification.recent.first).to eq newer
      end
    end
  end

  describe 'メソッド' do
    let(:notification) { FactoryBot.create(:notification, days_before: 7) }

    describe '#flower' do
      it '関連する花を返すこと' do
        expect(notification.flower).to eq notification.flower_mountain.flower
      end
    end

    describe '#mountain' do
      it '関連する山を返すこと' do
        expect(notification.mountain).to eq notification.flower_mountain.mountain
      end
    end

    describe '#mark_as_sent!' do
      it '送信済みフラグを立てること' do
        expect {
          notification.mark_as_sent!
        }.to change { notification.reload.sent }.from(false).to(true)
      end
    end

    describe '#title' do
      it '通知タイトルを返すこと' do
        expect(notification.title).to include(notification.flower.name)
        expect(notification.title).to include('見頃通知')
      end
    end

    describe '#message' do
      it '通知メッセージを返すこと' do
        message = notification.message
        expect(message).to include(notification.mountain.name)
        expect(message).to include(notification.flower.name)
        expect(message).to include('7日')
      end
    end
  end
end
