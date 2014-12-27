require 'test_helper'

class ArticlesPublishTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:angelo)
	end

	test "should be able to publish" do
		log_in_as(@user)
		get new_article_path(@user)
		assert_difference 'Article.count', 1 do
		post articles_path, article: { title: "Shit archer says",
																	 content: "LANA!!!!"
																 }
		end
	end

	test "should not be able to publish invalid articles" do
		log_in_as(@user)
		get new_article_path(@user)
		assert_no_difference 'Article.count' do
		post articles_path, article: { title: "     ",
																	 content: "        "
																 }
		end
	end

	test "should not see drafts in post" do
	 #note: cannot post to draft so only draft articles will be from fixtures
		log_in_as(@user)
		get new_article_path(@user)
		assert_difference 'Article.count', 1 do
		post articles_path, article: { title: "some post",
																	 content: "some good content",
																 }
		end
		assert_redirected_to @user
		follow_redirect!
		assert_match "some good content", response.body
		assert_no_match "draftking", response.body
	end

	test "should see drafts only in draft-view after posting a non-draft post" do
		log_in_as(@user)
		get new_article_path(@user)
		assert_difference 'Article.count', 1 do
		#post valid post
		post articles_path, article: { title: "This is not a draft",
																	 content: "some not so good content",
																 }
		end
		#get draft page
		get drafts_user_path(@user)
		assert_match "DraftKing", response.body
		assert_no_match "This is not a draft", response.body
	end

end
