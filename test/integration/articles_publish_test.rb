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

	# TODO lol make this one day work since draft: true does not 
	# post to params directly but instead posts into the column.
	# the code needs params for params[:submit] button or even
	# params[:draft] made here to tell the code 'hey yes i am a draft'
	#test "should not see draft in my posts" do
	#	log_in_as(@user)
	#	get new_article_path(@user)
	#	assert_difference 'Article.count', 1 do
	#	post articles_path, article: { title: "draftking",
	#																 content: "thisbeledraft",
	#																 draft: true
	#															 }
	#	end
	#	assert_redirected_to @user
	#	follow_redirect!
	#	assert_no_match "draftking", response.body
	#end

	#test "should see drafts only in draft-view after posting a draft" do
	#end

	#test "should see real posts only in my post after posting a real post" do
	#end

end
