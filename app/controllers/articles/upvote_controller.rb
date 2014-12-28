class Articles::UpvoteController < ApplicationController
  #before_action logged_in

	def upvote
		respond_to do |format|
			format.html { redirect_to :back }
			format.js { render inline: "location.reload();" }
		end
	end

end
