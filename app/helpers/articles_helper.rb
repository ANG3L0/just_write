module ArticlesHelper

	private

		def logged_in_and_not_me
			@article = Article.find_by(id: params[:id])
			@user = @article.user
			unless (logged_in? && !current_user?(@user))
				redirect_to root_url
			end
		end

end
