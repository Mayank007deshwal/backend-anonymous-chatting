require "test_helper"

class ConversationControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get conversation_create_url
    assert_response :success
  end
end
