require 'test_helper'

class RestrictedAccessesTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:angelo)
		@other = users(:arthur)
  end

  test "should not be able to access email nor password edit pages" do
    get change_passwords_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
    get change_emails_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

	test "should be able to post for myself" do
		log_in_as(@user)
		get new_article_path(@user)
		assert_template 'articles/new'
	end

	test "should not be able to post for other users" do
		get login_path
		log_in_as(@user)
		assert_redirected_to @user
		get new_article_path(@other)
		assert_redirected_to root_url
	end

end
