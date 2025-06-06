require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:flower_mountain) { create(:flower_mountain) }

  before { sign_in user }

  describe "GET /favorites" do
    it "正常にレスポンスを返すこと" do
      get favorites_path
      expect(response).to have_http_status(:success)
    end

    it "ユーザーのお気に入りのみ表示すること" do
      # 自分のお気に入り
      my_flower = create(:flower, name: "自分用の花")
      my_mountain = create(:mountain, name: "自分用の山")
      my_flower_mountain = create(:flower_mountain, flower: my_flower, mountain: my_mountain)
      my_favorite = create(:favorite, user: user, flower_mountain: my_flower_mountain)

      # 他人のお気に入り（完全に別のflower_mountainを用意）
      other_flower = create(:flower, name: "他人用の花")
      other_mountain = create(:mountain, name: "他人用の山")
      other_flower_mountain = create(:flower_mountain, flower: other_flower, mountain: other_mountain)
      other_favorite = create(:favorite, user: other_user, flower_mountain: other_flower_mountain)

      get favorites_path
      expect(response.body).to include(my_flower.name)
      expect(response.body).not_to include(other_flower.name)
    end
  end

  describe "POST /favorites" do
    it "お気に入りが作成されること" do
      expect {
        post favorites_path, params: { flower_mountain_id: flower_mountain.id }
      }.to change(Favorite, :count).by(1)
    end

    it "リダイレクトすること" do
      post favorites_path, params: { flower_mountain_id: flower_mountain.id }
      expect(response).to redirect_to(flower_mountain)
    end
  end

  describe "DELETE /favorites/:id" do
    let!(:favorite) { create(:favorite, user: user, flower_mountain: flower_mountain) }

    it "お気に入りが削除されること" do
      expect {
        delete favorite_path(favorite)
      }.to change(Favorite, :count).by(-1)
    end

    it "リダイレクトすること" do
      delete favorite_path(favorite)
      expect(response).to redirect_to(flower_mountain)
    end
  end

  context "ログインしていない場合" do
    before { sign_out user }

    it "リダイレクトされること" do
      get favorites_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
