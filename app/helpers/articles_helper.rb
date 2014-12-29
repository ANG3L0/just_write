module ArticlesHelper

	private

		def logged_in_and_not_me
			@article = Article.find_by(id: params[:id])
			unless @article.nil?
				@user = @article.user
			end
			#if article is invalid and therefore nil, go to rooturl
			unless (logged_in? && @article && !current_user?(@user))
				redirect_to root_url
			end
		end

end
