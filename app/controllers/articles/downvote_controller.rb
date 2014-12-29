class Articles::DownvoteController < ApplicationController
	include ArticlesHelper
  before_action :logged_in_and_not_me, only: [:downvote]
	
	def downvote
		new_score = @article.rating - 1
		@article.update_attribute(:rating, new_score)
		if @article.save
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
