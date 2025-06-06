require 'rails_helper'

RSpec.describe "Likes", type: :request do
  include Rails.application.routes.url_helpers
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:post_record) { create(:post, user: other_user, image_url: fixture_file_upload(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg")) }

  before { sign_in user }

  describe "POST /likes" do
    context "まだいいねしていない投稿の場合" do
      it "いいねが作成されること" do
        expect {
          post post_likes_path(post_record), params: {}
        }.to change(Like, :count).by(1)
      end

      it "HTMLリクエストでリダイレクトすること" do
        post post_likes_path(post_record), params: {}
        expect(response).to redirect_to(post_path(post_record))
      end
    end

    context "存在しない投稿の場合" do
      it "404エラーが発生すること" do
        post post_likes_path(99999), params: {}
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /likes/:id" do
    let!(:like) { create(:like, user: user, post: post_record) }

    it "いいねが削除されること" do
      expect {
        delete like_path(like)
      }.to change(Like, :count).by(-1)
    end

    it "投稿詳細ページにリダイレクトすること" do
      delete like_path(like)
      expect(response).to redirect_to(post_path(post_record))
    end

    context "他人のいいねを削除しようとした場合" do
      let!(:other_like) { create(:like, user: other_user, post: post_record) }

      it "404エラーが発生すること" do
        delete like_path(other_like)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context "ログインしていない場合" do
    before { sign_out user }

    it "POST時にログインページへリダイレクトすること" do
      post post_likes_path(post_record), params: {}
      expect(response).to redirect_to(new_user_session_path)
    end

    it "DELETE時にログインページへリダイレクトすること" do
      like = create(:like, user: user, post: post_record)
      delete like_path(like)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
