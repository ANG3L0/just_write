require 'test_helper'

class ArticleTest < ActiveSupport::TestCase

	def setup
		@user = users(:angelo)
		@article = @user.articles.build(content: "He sat on the wall, had a great fall", 
																		title: "Humpty Dumpty")
	end

	test "should be able to have valid article" do
		assert @article.valid?
	end

	test "should have user_id" do
		@article.user_id = nil
		assert_not @article.valid?
	end
	
	test "should not be able to have empty content" do
		@article.content = "   "
		assert_not @article.valid?	
	end

	test "should not be able to have empty title" do
		@article.title = "   "
		assert_not @article.valid?	
	end

	test "title cannot be more than 140 characters" do
		@article.title = "a" * 141
		assert_not @article.valid?
	end

	#this test isn't that valid since different views
	#can give different ordering
	#test "order should be most recent first" do
	#	assert_equal Article.first, articles(:most_recent)
	#end

end
