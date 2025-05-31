require "test_helper"

class FlowerMountainsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get flower_mountains_index_url
    assert_response :success
  end

  test "should get show" do
    get flower_mountains_show_url
    assert_response :success
  end
end
