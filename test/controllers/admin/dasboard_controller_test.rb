require 'test_helper'

class Admin::DasboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_dasboard_index_url
    assert_response :success
  end

end
