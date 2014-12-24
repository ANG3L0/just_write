require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:angelo)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert testuse_logged_in?
  end

  test "current user returns nil when remember digest is incorrect" do
    @user.update_attribute(:remember_digest, User.digest('blah dude'))
    assert_nil current_user
  end

end
