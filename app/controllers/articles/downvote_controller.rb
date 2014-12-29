class Articles::DownvoteController < ApplicationController
	include ArticlesHelper
  before_action :logged_in_and_not_me, only: [:downvote]
	
	def downvote
		#@user here is the user being voted on as seen in before_action
		#update voted user score and update articles score
		new_voted_score = @user.score_in - User.voting_power(current_user)
		new_score = @article.rating - User.voting_power(current_user)
		#suck score out of voter; update voter score
		new_voter_score = current_user.score_out + 1
		#update attributes and save
		@article.update_attribute(:rating, new_score)
		#if downvoted enough to be 0, do not let score_in be negative
		if (new_voted_score >= 0)
			@user.update_attribute(:score_in, new_voted_score)
		end
		current_user.update_attribute(:score_out, new_voter_score)
		if @article.save && current_user.save && @user.save
			respond_to do |format|
				format.html { redirect_to :back }
				format.js
			end
		else
			@article.destroy
			respond_to do |format|
				format.html { 
					flash[:success] = "Grats, you've destroyed someone else's hard work. I hope you're happy."
					redirect_to :back 
				}
				format.js {
					flash.now[:success] = "Grats, you've destroyed someone else's hard work. I hope you're happy."
				}
			end
		end
	end


end
