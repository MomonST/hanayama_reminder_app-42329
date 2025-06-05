require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /index" do
    context "未ログインの場合" do
      it "正常にレスポンスを返すこと" do
        get root_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ログイン済みの場合" do
      let(:user) { create(:user, region: "関東") }
      before { sign_in user }

      let!(:mountain) { create(:mountain, region: "関東") }
      let!(:flower) { create(:flower) }
      let!(:flower_mountain) { create(:flower_mountain, flower: flower, mountain: mountain, peak_month: 4) }
      let!(:notification) { create(:notification, user: user, flower_mountain: flower_mountain) }
      let!(:post) { create(:post, user: user, flower_mountain: flower_mountain) }

      it "正常にレスポンスを返すこと" do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it "見頃の花を取得すること" do
        blooming_flower = create(:flower, bloom_start_month: Date.today.month, bloom_end_month: Date.today.month)
        get root_path
        expect(assigns(:blooming_flowers)).to include(blooming_flower)
      end

      it "人気の山を取得すること" do
        create_list(:post, 3, mountain: mountain)
        get root_path
        expect(assigns(:popular_mountains)).to include(mountain)
      end

      it "最新の投稿を取得すること" do
        recent_posts = create_list(:post, 3, user: user, flower_mountain: flower_mountain)
        get root_path
        expect(assigns(:recent_posts)).to include(*recent_posts)
      end

      it "通知を取得すること" do
        notifications = create_list(:notification, 3, user: user, flower_mountain: flower_mountain)
        get root_path
        expect(assigns(:notifications)).to include(*notifications)
      end
    end
  end
end
