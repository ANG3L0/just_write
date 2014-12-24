require 'test_helper'

class UsersChangePasswordTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:angelo)
  end

  test "should be able to change password" do
    log_in_as(@user)
    get change_passwords_user_path(@user)
    assert_template 'users/change_passwords/change_passwords'
    patch change_passwords_user_path(@user), user: { password: "foobar2", password_confirmation: "foobar2" }
    assert_redirected_to @user
    assert_not flash.empty?
  end

  test "should not be able to change to bad" do
    log_in_as(@user)
    get change_passwords_user_path(@user)
    assert_template 'users/change_passwords/change_passwords'
    patch change_passwords_user_path(@user), user: { password: "oobar", password_confirmation: "oobar" }
    assert_template 'users/change_passwords/change_passwords'
  end

  test "change password and then try to log in again" do
    log_in_as(@user)
    get change_passwords_user_path(@user)
    assert_template 'users/change_passwords/change_passwords'
    patch change_passwords_user_path(@user), user: { password: "foobarxxx", password_confirmation: "foobarxxx" }
    assert_redirected_to @user
    delete logout_path
    assert_redirected_to root_url
    @user.reload
    #old password should not work
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: @user.email, password: "foobar" }
    assert_not flash.empty?
    assert_template 'sessions/new'
    #new password should work
    post login_path, session: { email: @user.email, password: "foobarxxx" }
    assert_redirected_to @user
  end
end
