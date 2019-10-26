require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get orders_show_url
    assert_response :success
  end

  test "should get receive_completed" do
    get orders_receive_completed_url
    assert_response :success
  end

end
