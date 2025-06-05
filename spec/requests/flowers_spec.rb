# spec/requests/flowers_spec.rb
require 'rails_helper'

RSpec.describe "Flowers", type: :request do
  let!(:flower) { FactoryBot.create(:flower) }
  let!(:mountain) { FactoryBot.create(:mountain, region: "関東") }
  let!(:flower_mountain) { FactoryBot.create(:flower_mountain, flower: flower, mountain: mountain) }

  describe "GET /index" do
    it "正常にレスポンスが返ること" do
      get flowers_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(flower.name)
    end

    it "検索パラメータが有効に機能すること" do
      get flowers_path, params: { search: flower.name }
      expect(response.body).to include(flower.name)
    end

    it "地域フィルタが有効に機能すること" do
      get flowers_path, params: { region: mountain.region }
      expect(response.body).to include(flower.name)
    end

    it "難易度フィルタが有効に機能すること" do
      get flowers_path, params: { difficulty: flower_mountain.difficulty_level }
      expect(response.body).to include(flower.name)
    end

    it "ソートパラメータが有効に機能すること" do
      get flowers_path, params: { sort: 'name' }
      expect(response.body).to include(flower.name)
    end
  end

  describe "GET /show" do
    it "正常にレスポンスが返ること" do
      get flower_path(flower)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(flower.name)
      expect(response.body).to include(flower.scientific_name)
    end
  end
end
