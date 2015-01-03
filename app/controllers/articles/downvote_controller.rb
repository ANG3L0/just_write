class Articles::DownvoteController < ApplicationController
	include ArticlesHelper
  before_action :logged_in_and_not_me, only: [:downvote]
	
	def downvote
		#@user here is the user being voted on as seen in before_action
		#update voted user score and update articles score
		new_voted_score = @user.score_in - current_user.voting_power
		new_score = @article.rating - current_user.voting_power
		#suck score out of voter; update voter score
		new_voter_score = current_user.score_out + 1
		#update article score
		@article.rating = new_score
		#if downvoted enough to be 0, do not let score_in be negative
		@user.score_in = new_voted_score > 0 ? new_voted_score : 0
		prev_power = current_user.voting_power
		current_user.update_attribute(:score_out, new_voter_score)
		@no_power = current_user.transition_to_no_power(prev_power)
		no_power_warning = @no_power ? "You now have no voting power. Write more articles to get more!" : ""
		if @user.save && @article.save
			respond_to do |format|
				format.html { 
					if @no_power
						flash[:danger] = no_power_warning
					end
					redirect_to :back 
				}
				format.js {
					if @no_power
						flash.now[:danger] = no_power_warning
					end
				}
			end
		else
			@article.destroy
			respond_to do |format|
				format.html { 
					flash[:success] = "Grats, you've destroyed someone else's hard work. I hope you're happy.  " + no_power_warning
					redirect_to :back 
				}
				format.js {
					flash.now[:success] = "Grats, you've destroyed someone else's hard work. I hope you're happy.  " + no_power_warning
				}
			end
		end
	end


end
