class Articles::UpvoteController < ApplicationController
	include ArticlesHelper
  before_action :logged_in_and_not_me, only: [:upvote]

	def upvote
		#@user here is the user being voted on as seen in before_action
		@user.score_in +=current_user.voting_power
		new_score = @article.rating + current_user.voting_power
		#suck score out of voter
		new_voter_score = current_user.score_out + 1
		#update attributes and save
		@article.rating = new_score
		prev_power = current_user.voting_power
		current_user.update_attribute(:score_out, new_voter_score)
		@no_power = current_user.transition_to_no_power(prev_power)
		if @user.save && @article.save
			respond_to do |format|
				format.html { 
					if @no_power
						flash[:danger] = "You now have no voting power. Write more articles to get more!"
					end
					redirect_to :back 
				}
				format.js { 
					if @no_power
						flash.now[:danger] = "You now have no voting power. Write more articles to get more!"
					end
				}
			end
		else 
			# no idea how upvoting can invalidate a post but o well
			raise
		end
	end

end
