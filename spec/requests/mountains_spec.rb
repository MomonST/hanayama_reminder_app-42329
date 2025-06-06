require 'rails_helper'

RSpec.describe "Mountains", type: :request do
  let!(:mountain) { FactoryBot.create(:mountain) }

  describe "GET /index" do
    it "正常にレスポンスが返ること" do
      get mountains_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(mountain.name)
    end

    it "検索パラメータが有効に機能すること" do
      get mountains_path, params: { search: mountain.name }
      expect(response.body).to include(mountain.name)
    end

    it "地域フィルタが有効に機能すること" do
      get mountains_path, params: { region: mountain.region }
      expect(response.body).to include(mountain.region)
    end

    it "難易度フィルタが有効に機能すること" do
      get mountains_path, params: { difficulty: mountain.difficulty_level }
      expect(response.body).to include(mountain.name)
    end
  end

  describe "GET /show" do
    it "正常にレスポンスが返ること" do
      get mountain_path(mountain)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(mountain.name)
    end
  end
end
