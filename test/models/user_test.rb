require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example user", email: "PerfectEmail@example.com", 
                     password: "password", password_confirmation: "password")
  end

  #basic inputs
  test "vanilla user should be valid" do
    assert @user.valid?
  end

  test "should not have name longer than 50 characters" do
   @user.name = "f" * 51
   assert_not @user.valid?
  end

  test "email should not be more than 100 characters" do
    @user.email = "f" * 101
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "         "
    assert_not @user.valid?
  end

  test "name should be present" do
    @user.name = "        "
    assert_not @user.valid?
  end
  #email formatting and uniqueness
  test "should accept valid email addresses" do
    valid_addresses = %w[joe@example.com BlAh@gmail.com MEMEME@memes.org
      first.last@hentai.jp alice+bob@broscience.cn]
    valid_addresses.each do |val_address|
      @user.email = val_address
      assert @user.valid?, "#{val_address.inspect} should be valid"
    end
  end

  test "should reject invalid email addresses" do
    invalid_addresses = %w[joe@example BlAhgmail.com MEMEME@memes.
      firstlasthentaijp alice+bob@ blah!!no@gmail.com]
    invalid_addresses.each do |inval_address|
      @user.email = inval_address
      assert_not @user.valid?, "#{inval_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password and confirmation should match" do
    @user.password_confirmation = "password2"
    assert_not @user.valid?
  end

  test "password should be at least 6 characters" do
    @user.password = "great"
    @user.password_confirmation = "great"
    assert_not @user.valid?
  end

end
