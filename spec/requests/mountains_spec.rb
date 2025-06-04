require 'rails_helper'

RSpec.describe "Mountains", type: :request do
  describe "GET /mountains" do
    it "works! (now write some real specs)" do
      get mountains_index_path
      expect(response).to have_http_status(200)
    end
  end
end
