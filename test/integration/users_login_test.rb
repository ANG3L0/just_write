require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:angelo)
  end

  test "login with invalid credentials" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_not flash.empty?
    #go do another request and make sure flash goes away
    get root_path
    assert flash.empty?
  end

  test "login with valid credientials and then logging out" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: @user.email, password: 'foobar' }
    assert testuse_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert flash.empty?
    delete logout_path
    assert_not testuse_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
  end
end
