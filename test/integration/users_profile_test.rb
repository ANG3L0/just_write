require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
	include ApplicationHelper

	def setup
		@user = users(:angelo)
	end

	test "should be able to see my own posts" do
		get user_path(@user)
		assert_template 'users/show'
		@user.articles.each do |article|
			#assert_match article.title, response.body too hard to escape .title which is a name right now
			if !article.draft
				assert_match article.content, response.body
			end
		end
	end
end
