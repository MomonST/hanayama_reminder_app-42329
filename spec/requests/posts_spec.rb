require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:flower_mountain) { create(:flower_mountain) }
  let(:post_record) { create(:post, user: user, flower_mountain: flower_mountain) }

  describe "GET #index" do
    it "正常にレスポンスが返ること" do
      get posts_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "正常にレスポンスが返ること" do
      get post_path(post_record)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    context "ログインしている場合" do
      before { sign_in user }
      it "正常にレスポンスが返ること" do
        get new_post_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get new_post_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        post: {
          flower_mountain_id: flower_mountain.id,
          content: 'テスト投稿',
          image_url: fixture_file_upload('spec/fixtures/test.jpg', 'image/jpeg')
        }
      }
    end

    context "ログインしている場合" do
      before { sign_in user }

      it "投稿が作成されること" do
        expect {
          post posts_path, params: valid_params
        }.to change(Post, :count).by(1)
      end

      it "投稿詳細ページにリダイレクトすること" do
        post posts_path, params: valid_params
        expect(response).to redirect_to(post_path(Post.last))
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        post posts_path, params: valid_params
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #edit" do
    context "投稿者本人の場合" do
      before { sign_in user }

      it "正常にレスポンスが返ること" do
        get edit_post_path(post_record)
        expect(response).to have_http_status(:success)
      end
    end

    context "他人の投稿の場合" do
      before { sign_in other_user }

      it "投稿一覧にリダイレクトされること" do
        get edit_post_path(post_record)
        expect(response).to redirect_to posts_path
      end
    end
  end

  describe "PATCH #update" do
    context "投稿者本人の場合" do
      before { sign_in user }

      it "投稿が更新されること" do
        patch post_path(post_record), params: { post: { content: "更新内容" } }
        expect(post_record.reload.content).to eq "更新内容"
      end
    end

    context "他人の投稿の場合" do
      before { sign_in other_user }

      it "更新できずに投稿一覧にリダイレクトされること" do
        patch post_path(post_record), params: { post: { content: "更新内容" } }
        expect(post_record.reload.content).not_to eq "更新内容"
        expect(response).to redirect_to posts_path
      end
    end
  end

  describe "DELETE #destroy" do
    context "投稿者本人の場合" do
      before { sign_in user }

      it "投稿が削除されること" do
        post_record # 先に作成
        expect {
          delete post_path(post_record)
        }.to change(Post, :count).by(-1)
      end
    end

    context "他人の投稿の場合" do
      before { sign_in other_user }

      it "削除できずに投稿一覧にリダイレクトされること" do
        delete post_path(post_record)
        expect(response).to redirect_to posts_path
      end
    end
  end
end
