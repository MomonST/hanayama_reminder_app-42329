require 'rails_helper'

RSpec.describe "通知機能", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:flower_mountain) { FactoryBot.create(:flower_mountain) }
  let!(:notification) { FactoryBot.create(:notification, user: user, flower_mountain: flower_mountain, days_before: 10) }

  before do
    # ログイン画面へ行く
    visit new_user_session_path

    # フォームに入力してログイン
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    # ここで本当にログインできてるか確認！
    expect(page).to have_content("ログアウト")
  end

  context "通知の削除" do
    it "通知を削除すると一覧から消える" do
      visit notifications_path

      # 削除前に通知が表示されていることを確認
      expect(page).to have_content(notification.title)

      # 削除ボタンをクリック（data-confirmがついているので、確認ダイアログにOKを送信）
      accept_confirm do
        find(".list-group-item-action .btn-outline-danger").click
      end

      # 削除後、通知が表示されなくなることを確認
      expect(page).to have_no_content(notification.title)
      expect(page).to have_content("通知はありません").or have_content("新しい通知が届くとここに表示されます")
    end
  end
end
