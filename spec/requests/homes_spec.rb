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
      let!(:mountain) { create(:mountain, region: "関東") }
      let!(:flower) { create(:flower) }
      let!(:flower_mountain) { create(:flower_mountain, flower: flower, mountain: mountain, peak_month: 4) }
      before { sign_in user }

      it "正常にレスポンスを返すこと" do
        create(:post, user: user, flower_mountain: flower_mountain, image_url: File.open(Rails.root.join('spec/fixtures/test.jpg')))
        get root_path
        expect(response).to have_http_status(:success)
      end

      it "見頃の花を取得すること" do
        get root_path
        expect(response.body).to include(flower.name)
      end

      it "人気の山を取得すること" do
        get root_path
        expect(response.body).to include(mountain.name)
      end

      it "最新の投稿を取得すること" do
        file = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg")
        post = create(:post, user: user, flower_mountain: flower_mountain, image_url: file)
        get root_path
        expect(response.body).to include(post.flower_mountain.mountain.name)
      end

      it "通知を取得すること" do
        notification = create(:notification, user: user, flower_mountain: flower_mountain, days_before: 7)
        get root_path
        expect(response.body).to include(notification.flower_mountain.flower.name)
        expect(response.body).to include(notification.flower_mountain.mountain.name)
      end
    end
  end
end
