require 'test_helper'

class ArticleVotingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:angelo)
		@user_article = @user.articles.first
		@other = users(:arthur)
		@other_article = @other.articles.first
		@power_user = users(:power)
		@power_article = articles(:power_article)
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

	test "should have voting power decrease to 0 after downvoting enough times" do
		log_in_as(@user)
		get user_url(@other)
		assert_difference '@user.voting_power', -1 do
			#10 times is the default number of times for a new user to lose their voting power
			5.times do
				#after 3 times, articles.first is referring to the second post since is now the first one
				xhr :patch, downvote_article_path(@other.articles.first.id), nil,  { HTTPS: "on", HTTP_REFERER: user_url(@other) }
				patch downvote_article_path(@other.articles.first.id), nil,  { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			end
			@user.reload
		end
		#now I have no power, my votes should not matter up or down
		assert_no_difference '@other.articles.first.rating' do
			5.times do
				xhr :patch, downvote_article_path(@other.articles.first.id), nil,  { HTTPS: "on", HTTP_REFERER: user_url(@other) }
				patch downvote_article_path(@other.articles.first.id), nil,  { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			end
		end
		assert_no_difference '@other.articles.first.rating' do
			5.times do
				xhr :patch, upvote_article_path(@other.articles.first.id), nil,  { HTTPS: "on", HTTP_REFERER: user_url(@other) }
				patch upvote_article_path(@other.articles.first.id), nil,  { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			end
		end
		#make sure massive voting won't give you negative voting power
		assert_equal @user.voting_power, 0
	end

	test "should have no voting power after upvoting enough times" do
		log_in_as(@user)
		get user_url(@other)
		assert_difference '@user.voting_power', -1 do
			5.times do
				xhr :patch, upvote_article_path(@other.articles.first.id), nil,  { HTTPS: "on", HTTP_REFERER: user_url(@other) }
				patch upvote_article_path(@other.articles.first.id), nil,  { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			end
			@user.reload
		end
	end

	test "should have power user destroy a post in one downvote (html)" do
		log_in_as(@power_user)
		get user_url(@other)
		assert_difference 'Article.count', -1 do
			patch downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
		end
	end
	test "should have power user destroy a post in one downvote (js)" do
		log_in_as(@power_user)
		get user_url(@other)
		assert_difference 'Article.count', -1 do
			xhr :patch, downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
		end
	end

	test "should not change user's voting power if they are up or downvoting an invalid article (html)" do
		log_in_as(@power_user)
		get user_url(@other)
		assert_difference '@power_user.score_out' do
			patch downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			@power_user.reload
		end
		assert_no_difference '@power_user.score_out' do
			patch downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			patch upvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			@power_user.reload
		end
	end

	test "should not change user's voting power if they are up or downvoting an invalid article (js)" do
		log_in_as(@power_user)
		get user_url(@other)
		assert_difference '@power_user.score_out' do
			xhr :patch, downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			@power_user.reload
		end
		assert_no_difference '@power_user.score_out' do
			xhr :patch, downvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			xhr :patch, upvote_article_path(@other_article.id), nil, { HTTPS: "on", HTTP_REFERER: user_url(@other) }
			@power_user.reload
		end
	end

	test "should see voting icons when logged in" do
		log_in_as(@user)
		get root_url
		assert_select "a[href=?]", upvote_article_path(@power_article)
	end

	test "should not see voting icons when not logged in" do
		get root_url
		assert_select "a[href=?]", upvote_article_path(@power_article), false
	end

end
