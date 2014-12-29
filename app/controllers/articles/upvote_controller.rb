class Articles::UpvoteController < ApplicationController
	include ArticlesHelper
  before_action :logged_in_and_not_me, only: [:upvote]

	def upvote
		new_score = @article.rating + 1
		@article.update_attribute(:rating, new_score)
		if @article.save
			respond_to do |format|
				format.html { redirect_to :back }
				format.js
			end
		else 
			# no idea how upvoting can invalidate a post but o well
			raise
		end
	end

end
