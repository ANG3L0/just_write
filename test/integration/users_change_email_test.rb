require 'test_helper'

class UsersChangeEmailTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:angelo)
		@other = users(:arthur)
  end


  test "should be able to change email" do
    log_in_as(@user)
    get change_emails_user_path(@user)
    assert_template 'users/change_emails/change_emails'
    patch change_emails_user_path(@user), user: { email: "newclassic@iggy.com", email_confirmation: "newclassic@iggy.com" }
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_equal @user.email, "newclassic@iggy.com"
  end

  test "should not be able to change to bad email" do
    log_in_as(@user)
    get change_emails_user_path(@user)
    assert_template 'users/change_emails/change_emails'
    patch change_emails_user_path(@user), user: { email: "invalid@", email_confirmation: "invalid@" }
    assert_template 'users/change_emails/change_emails'
    assert_not_equal @user.email, "invalid@"
  end
  
  test "should not be able to change to non-matching emails" do
    log_in_as(@user)
    get change_emails_user_path(@user)
    assert_template 'users/change_emails/change_emails'
    patch change_emails_user_path(@user), user: { email: "valid@aids.com", email_confirmation: "invalid@aids.com" }
    assert_template 'users/change_emails/change_emails'
    @user.reload
    assert_not_equal @user.email, "valid@aids.com"
    assert_equal @user.email, "angelowong0x59@gmail.com"
  end

	test "should not be able to change email as a different user" do
		log_in_as(@other)
		get change_emails_user_path(@user)
		assert_redirected_to root_url
    patch change_emails_user_path(@user), user: { email: "valid@aids.com", email_confirmation: "valid@aids.com" }
		assert_redirected_to root_url
		@user.reload
		assert_not_equal @user.email, "valid@aids.com"
		assert_equal @user.email, "angelowong0x59@gmail.com"
	end
end
