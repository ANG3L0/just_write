class PublicPagesController < ApplicationController

  def home
		@articles = Article.paginate(page: params[:page], per_page: 15).published_and_in_score_order
  end

  def contact
  end

	def about
	end

end
