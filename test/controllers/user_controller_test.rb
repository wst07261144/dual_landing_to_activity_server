require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get register" do
    get :register
    assert_response :success
  end

  test "should get logout" do
    get :logout
    assert_response :success
  end

  test "should get register" do
    get :register
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

end