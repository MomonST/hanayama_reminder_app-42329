require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:user) { create(:user) }
  let(:flower) { create(:flower) }
  let(:mountain) { create(:mountain) }
  let(:flower_mountain) { FactoryBot.create(:flower_mountain) }
  let(:notification) { create(:notification, user: user, flower_mountain: flower_mountain, days_before: 30) }

  describe "GET #index" do
    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "正常にレスポンスが返る" do
        get notifications_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("通知一覧")
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        get notifications_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #new" do
    before { sign_in user }

    it "正常にレスポンスが返る" do
      get new_notification_path(flower_mountain_id: flower_mountain.id)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("通知設定")
    end
  end

  describe "POST #create" do
    before { sign_in user }

    context "有効なパラメータの場合" do
      it "通知が作成される" do
        expect {
          post notifications_path, params: {
            notification: {
              flower_mountain_id: flower_mountain.id,
              days_before: 10
            }
          }
        }.to change(Notification, :count).by(1)

        expect(response).to redirect_to(notifications_path)
      end
    end

    context "無効なパラメータの場合" do
      it "通知が作成されない" do
        expect {
          post notifications_path, params: {
            notification: {
              flower_mountain_id: nil,
              days_before: nil
            }
          }
        }.not_to change(Notification, :count)

        expect(response.body).to include("通知設定")
      end
    end
  end

  describe "GET #edit" do
    before { sign_in user }

    it "正常にレスポンスが返る" do
      get edit_notification_path(notification)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("通知設定")
    end
  end

  describe "PATCH #update" do
    before { sign_in user }

    context "有効なパラメータの場合" do
      it "通知が更新される" do
        patch notification_path(notification), params: {
          notification: { days_before: 15 }
        }
        expect(notification.reload.days_before).to eq 15
        expect(response).to redirect_to(notifications_path)
      end
    end

    context "無効なパラメータの場合" do
      it "通知が更新されない" do
        original_days_before = notification.days_before
        patch notification_path(notification), params: {
          notification: { days_before: nil }
        }
        expect(notification.reload.days_before).to eq original_days_before
        expect(response.body).to include("通知設定")
      end
    end
  end

  describe "DELETE #destroy" do
    before { sign_in user }

    it "通知が削除される" do
      notification_to_delete = create(:notification, user: user, flower_mountain: flower_mountain)
      expect {
        delete notification_path(notification_to_delete)
      }.to change(Notification, :count).by(-1)
      expect(response).to redirect_to(notifications_path)
    end
  end
end
