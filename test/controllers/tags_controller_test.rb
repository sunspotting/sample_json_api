require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get tags_update_url
    assert_response :success
  end
end
