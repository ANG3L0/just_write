require 'test_helper'

class PublicNavTest < ActionDispatch::IntegrationTest
  test "layout links from home" do
    get root_path
    assert_template 'public_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", contact_path
  end
end
