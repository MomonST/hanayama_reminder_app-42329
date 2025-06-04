require 'rails_helper'

RSpec.describe "FlowerMountains", type: :request do
  describe "GET /flower_mountains" do
    it "works! (now write some real specs)" do
      get flower_mountains_index_path
      expect(response).to have_http_status(200)
    end
  end
end
