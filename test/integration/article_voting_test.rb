require 'test_helper'

class ArticleVotingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:angelo)
		@user_article = @user.articles.first
		@other = users(:arthur)
		@other_article = @other.articles.first
  end

	test "should not be able to vote if not logged in" do
		get user_url(@other)
		assert_no_difference '@other_article.rating' do
			patch upvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			#xml http request version for js
			xhr :patch, upvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			@other_article.reload
		end
		assert_no_difference '@other_article.rating' do
			patch downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			#xml http request version for js
			xhr :patch, downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			@other_article.reload
		end
	end
	
	test "should be able to vote for other users, up or down (html)" do
		log_in_as(@user)
		get user_url(@other)
		assert_difference '@other_article.rating', 1 do
			patch upvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			@other_article.reload
		end
		assert_difference '@other_article.rating', -1 do
			patch downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			@other_article.reload
		end
	end
	test "should be able to vote for other users, up or down (js)" do
		log_in_as(@user)
		get user_url(@other)
		assert_difference '@other_article.rating', 1 do
			xhr :patch, upvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			@other_article.reload
		end
		assert_difference '@other_article.rating', -1 do
			xhr :patch, downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			@other_article.reload
		end
	end

	test "should be able to destroy other people's posts if voted below 0 (html)" do
		log_in_as(@user)
		assert_difference 'Article.count', -1 do
			patch downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			patch downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			patch downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			patch downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
		end
	end
	test "should be able to destroy other people's posts if voted below 0 (js)" do
		log_in_as(@user)
		assert_difference 'Article.count', -1 do
			xhr :patch, downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			xhr :patch, downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			xhr :patch, downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			xhr :patch, downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
		end
		assert_not flash.empty?
	end

	test "should not be able to vote for myself" do
		log_in_as(@user)
		get user_url(@user)
		assert_no_difference '@user_article.rating' do
			patch upvote_article_path(@user_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@user) }
			xhr :patch, upvote_article_path(@user_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@user) }
			@user_article.reload
		end
		assert_no_difference '@user_article.rating' do
			patch downvote_article_path(@user_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@user) }
			xhr :patch, downvote_article_path(@user_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@user) }
			@user_article.reload
		end
	end

end
