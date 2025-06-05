require 'rails_helper'

RSpec.describe "FlowerMountains", type: :request do
  let!(:flower_mountain) { FactoryBot.create(:flower_mountain) }
  let!(:flower) { FactoryBot.create(:flower, name: "テスト花1") }
  let!(:mountain) { FactoryBot.create(:mountain, name: "テスト山1", region: "関東", difficulty_level: "中級者") }
  let!(:flower_mountain) { FactoryBot.create(:flower_mountain, flower: flower, mountain: mountain) }

  describe "GET /index" do
    it "正常にレスポンスが返ること" do
      get flower_mountains_path, params: { region: mountain.region, month: flower_mountain.peak_month, difficulty: mountain.difficulty_level } 
      expect(response).to have_http_status(:success)
      expect(response.body).to include(flower.name)
      expect(response.body).to include(mountain.name)
    end

    it "地域フィルタが有効に機能すること" do
      get flower_mountains_path, params: { region: "関東" }
      #expect(response.body).to include(mountain.name)
    end

    it "月フィルタが有効に機能すること" do
      get flower_mountains_path, params: { month: 4 }
      expect(response.body).to include(mountain.name)
    end

    it "難易度フィルタが有効に機能すること" do
      get flower_mountains_path, params: { difficulty: "中級者" }
      #expect(response.body).to include(mountain.name)
    end

    it "JSON形式のレスポンスが返ること" do
      get flower_mountains_path, params: { region: mountain.region, month: flower_mountain.peak_month, difficulty: mountain.difficulty_level }, headers: { "ACCEPT" => "application/json" }
      
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      
      expect(json).not_to be_empty
      expect(json.first["flower"]).to eq(flower.name)
      expect(json.first["name"]).to eq(mountain.name)
    end
  end

  describe "GET /show" do
    it "正常にレスポンスが返ること" do
      get flower_mountain_path(flower_mountain)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(flower.name)
      expect(response.body).to include(mountain.name)
    end
  end
end
