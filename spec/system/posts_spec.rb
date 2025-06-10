require 'rails_helper'

RSpec.describe "Posts", type: :system do
  # テストデータのセットアップ
  let!(:user) { create(:user) }
  let!(:flower) { create(:flower) }
  let!(:mountain) { create(:mountain) }
  let!(:flower_mountain) { create(:flower_mountain, flower: flower, mountain: mountain) }
  let!(:other_user) { create(:user) }

  # Capybaraのドライバー設定
  before do
    # スクリーンショットを必ず確認してください
    driven_by(:selenium_chrome_headless)
    # Capybaraのデフォルト待機時間を少し長めに設定する（任意だが、デバッグに役立つことがある）
    # Capybara.default_max_wait_time = 5 
  end

  #--- ログイン済みの場合のテスト ---
  context 'ログイン済みの場合' do
    before do
      sign_in(user) # supportモジュールで定義したフォーム入力ログイン
    end

    it "投稿を作成・表示できること" do
      visit new_post_path

      # new.html.erb の ID 属性を直接指定して、要素の特定を確実にする
      # <div class="mb-3">
      #   <%= f.label :flower_mountain_id, "花山スポット", class: "form-label" %>
      #   <%= f.collection_select :flower_mountain_id, ... id="post_flower_mountain_id" が生成されるはず
      # </div>
      select "#{mountain.name} - #{flower.name}", from: "post_flower_mountain_id" # IDを直接指定

      # <div class="mb-3">
      #   <%= f.label :content, "コメント", class: "form-label" %>
      #   <%= f.text_area :content, ... id="post_content" が生成されるはず
      # </div>
      fill_in "post_content", with: "美しい花と山の写真をシェアします！" # IDを直接指定

      # <div class="input-group mb-3">
      #   <%= f.file_field :image_url, ..., id: "post-image" %>
      # </div>
      attach_file "post-image", Rails.root.join("spec/fixtures/test.jpg") # IDを直接指定

      click_button "投稿する"

      expect(page).to have_content "投稿が完了しました" # コントローラのアクションでは「投稿が完了しました」
      expect(page).to have_content "美しい花と山の写真をシェアします！"
      expect(page).to have_css("img[src$='test.jpg']")
    end

    it "投稿を編集できること" do
      post = create(:post, user: user, flower_mountain: flower_mountain, content: "元の内容")

      visit edit_post_path(post)
      
      # editフォームもnewと同じID構造と仮定 (一般的に同じです)
      fill_in "post_content", with: "編集後の内容" # IDを直接指定
      click_button "更新"

      # コントローラのアクションでは「投稿を更新しました」
      expect(page).to have_content "投稿を更新しました" # ここを「投稿を更新しました」に修正済
      expect(page).to have_content "編集後の内容"
    end

    it "投稿を削除できること", js: true do # js: true は必須
      post = create(:post, user: user, flower_mountain: flower_mountain)

      visit post_path(post)
      
      # 削除リンクが存在することを確認してからクリック
      expect(page).to have_link "削除"

      # ここに短時間の待機を入れてみる（JavaScriptの読み込み・実行の遅延対策）
      # sleep 0.5 # 必要であればコメントアウトを解除して試す

      # accept_confirmのタイムアウトを延長し、確実にダイアログを待つ
      accept_confirm(wait: 10) do # タイムアウトを10秒まで延長して試す
        click_link "削除"
      end

      # コントローラのアクションでは「投稿を削除しました」
      expect(page).to have_content "投稿を削除しました"
      expect(page).not_to have_content post.content
    end

    it "他人の投稿は編集・削除できないこと" do
      other_post = create(:post, user: other_user, flower_mountain: flower_mountain, content: "他人の投稿")

      visit post_path(other_post)
      expect(page).not_to have_link "編集"
      expect(page).not_to have_link "削除"
    end

    it "投稿にいいねできること" do
      post = create(:post, user: other_user, flower_mountain: flower_mountain)

      visit post_path(post)
      expect(page).to have_selector('a.like-button') # いいねボタンが存在することを確認
      
      # いいねカウントの初期値を取得しておく
      initial_likes_count = find('.like-count').text.to_i

      find('a.like-button').click

      # Ajaxリクエストが完了し、DOMが更新されるのを待つために、
      # likedクラスの存在と、いいねカウントが変化したことの両方をアサーションとして利用
      expect(page).to have_selector('a.like-button.liked', wait: 5) # いいね済み状態
      expect(page).to have_selector('.like-count', text: (initial_likes_count + 1).to_s, wait: 5) # いいね数が1増えたことを確認
      expect(post.reload.likes_count).to eq(1) # DBの確認
    end

    it "投稿のいいねを解除できること" do
      post = create(:post, user: other_user, flower_mountain: flower_mountain)
      create(:like, user: user, post: post) # 事前にいいねしておく

      visit post_path(post)
      # いいね済み状態のボタンが存在することを確認
      expect(page).to have_selector('a.like-button.liked')

      # いいねカウントの初期値（1）を取得しておく
      initial_likes_count = find('.like-count').text.to_i

      find('a.like-button.liked').click

      # いいね解除後の状態（likedクラスがないこと）と、いいねカウントが変化したことの両方をアサーションとして利用
      expect(page).not_to have_selector('a.like-button.liked', wait: 5) # いいね解除後の状態
      expect(page).to have_selector('.like-count', text: (initial_likes_count - 1).to_s, wait: 5) # いいね数が1減ったことを確認
      expect(post.reload.likes_count).to eq(0) # DBの確認
    end
  end

  #--- ログインしていない場合のテスト ---

  context 'ログインしていない場合' do
    before do
      visit destroy_user_session_path
    end
    it "投稿ページにアクセスするとログインページにリダイレクトされること" do
      visit new_post_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content "ログインもしくはアカウント登録してください"
    end

    it '投稿にいいねできない（いいねボタンが表示されない）こと' do
      post = create(:post, user: other_user, flower_mountain: flower_mountain)
      visit post_path(post)
      expect(page).not_to have_link "いいね"
    end
  end
end
