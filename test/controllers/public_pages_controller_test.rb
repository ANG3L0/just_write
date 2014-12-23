require 'test_helper'

class PublicPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get signup" do
    get :signup
    assert_response :success
  end

end
