class Articles::UpvoteController < ApplicationController
	include ArticlesHelper
  before_action :logged_in_and_not_me, only: [:upvote]

	def upvote
		#@user here is the user being voted on as seen in before_action
		new_voted_score = @user.score_in + current_user.voting_power
		new_score = @article.rating + current_user.voting_power
		#suck score out of voter
		new_voter_score = current_user.score_out + 1
		#update attributes and save
		@article.update_attribute(:rating, new_score)
		@user.update_attribute(:score_in, new_voted_score)
		current_user.update_attribute(:score_out, new_voter_score)
		if @article.save && current_user.save && @user.save
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
