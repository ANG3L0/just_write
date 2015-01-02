require 'test_helper'

class ArticlesPublishTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:angelo)
		@user_article = @user.articles.first
		@other = users(:arthur)
		@other_article = @other.articles.first
	end

	test "should be able to publish" do
		log_in_as(@user)
		get new_user_article_path(@user)
		assert_difference 'Article.count', 1 do
		post articles_path, article: { title: "Shit archer says",
																	 content: "LANA!!!!"
																 }
		end
	end

	test "should not be able to publish invalid articles" do
		log_in_as(@user)
		get new_user_article_path(@user)
		assert_no_difference 'Article.count' do
		post articles_path, article: { title: "     ",
																	 content: "        "
																 }
		end
	end

	test "should not see drafts in post" do
	 #note: cannot post to draft so only draft articles will be from fixtures
		log_in_as(@user)
		get new_user_article_path(@user)
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
		get new_user_article_path(@user)
		assert_difference 'Article.count', 1 do
		#post valid post
		post articles_path, article: { title: "This is not a draft",
																	 content: "some not so good content",
																 }
		end
		#get draft page
		get user_drafts_path(@user)
		assert_match "DraftKing", response.body
		assert_no_match "This is not a draft", response.body
	end

	test "should not be able to post for other users" do
		get login_path
		log_in_as(@other)
		assert_redirected_to @other
		get new_user_article_path(@user)
		assert_redirected_to root_url
		assert_difference '@other.articles.count' do
			post articles_path, article: { title: "hacker", content: "I hack this." }
		end
		assert_no_difference '@user.articles.count' do
			post articles_path, article: { title: "hacker", content: "I hack this." }
		end
	end

	test "should be able to delete posts for myself" do
		log_in_as(@user)
		assert_difference 'Article.count', -1 do
			delete article_path(@user_article)
		end
		assert_redirected_to user_drafts_url(@user)
	end

	test "should not be able to delete posts for other users" do
	  log_in_as(@other)	
		assert_no_difference 'Article.count' do
			delete article_path(@user_article)
		end
		assert_redirected_to root_url
	end

	test "should be able to edit posts for self" do
	  log_in_as(@user)	
		patch article_path(@user.articles.first.id), 
			article: { title: "title",
								 content: "content"
			}
		assert_equal @user.articles.first.title, "title"
		assert_equal @user.articles.first.content, "content"
	end

	test "should not be able to edit posts for other users" do
	  log_in_as(@other)	
		patch article_path(@user.articles.first.id), 
			article: { title: "title",
								 content: "content"
			}
		assert_not_equal @user.articles.first.title, "title"
		assert_not_equal @user.articles.first.content, "content"
	end

	test "should be able to see other people post" do
		get user_path(@other)
		title = @other_article.title
		content = @other_article.content
		assert_match title, response.body
		assert_match content, response.body
	end

end
