class PublicPagesController < ApplicationController

  def home
		@articles = Article.all.published_and_in_score_order
  end

  def contact
  end

	def about
	end

end
