require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest

  test "should be able to signup with valid info" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: { name: "Angelo",
                             email: "example@example.org",
                             password: "foobar",
                             password_confirmation: "foobar" }
    end
    follow_redirect!
    assert_template 'users/show'
  end

  test "should not be able to signup with invalid info" do
    get signup_path
    #bad email
    assert_no_difference 'User.count' do
      post users_path, user: { name: "Angelo",
                               email: "invalid@blah",
                               password: "foobar",
                               password_confirmation: "foobar" }
    end
    assert_template 'users/new'
    #bad name
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "   ",
                               email: "valid@example.com",
                               password: "foobar",
                               password_confirmation: "foobar" }
    end
    assert_template 'users/new'
    #bad password
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "angelo",
                               email: "valid@blah.com",
                               password: "foobar",
                               password_confirmation: "foobar2" }
    end
    assert_template 'users/new'
  end
end
