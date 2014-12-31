class ArticlesController < ApplicationController
	before_action :logged_in_user, only: [:new, :create, :update, :destroy]
	before_action :correct_user_lookup, only: [:edit, :update, :destroy]
	before_action :correct_user, only: [:new]


	#show a particular post corresponding to a user
	def show
		@article = Article.find_by(id: params[:id])
		if @article.nil?
			redirect_to root_url
		else
		end
	end

	#create a new article
	def new
		@user = current_user
		@article = @user.articles.new
	end

	#first time editing drafts or creating a post
	#no article ID associated with this yet
	def create
		@article = current_user.articles.build(article_params)
		if @article.save
			if params[:submit] == 'Save draft'
				@article.update_attribute(:draft, true)
				redirect_to user_drafts_path(current_user)
			else
				flash[:success] = "Article published!"
				@article.update_attribute(:draft, false)
				redirect_to current_user
			end
		else
			render 'articles/new'
		end
	end

	#editing drafts: pretty much same as create except article ID is associated
	#and we render the text for them
	def edit
		render 'articles/new'
	end

	def update
		if @article.update_attributes(article_params)
			if params[:submit] == 'Save draft'
				flash[:success] = "Draft saved!"
				@article.update_attribute(:draft, true)
				redirect_to user_drafts_path(current_user)
			else
				flash[:success] = "Article published!"
				@article.update_attribute(:draft, false)
				redirect_to current_user
			end
		else
			render 'articles/new'
		end
	end

	#delete an article (draft or not)
	def destroy
		@article.destroy
		flash[:success] = "Post deleted"
		redirect_to user_drafts_path(current_user)
	end

	private 
		
		def correct_user_lookup
			@article = current_user.articles.find_by(id: params[:id])
			redirect_to root_url if @article.nil?
		end

		def article_params
			params.require(:article).permit(:title, :content)
		end

end
