class ArticlesController < ApplicationController
	before_action :logged_in_user, only: [:new, :create, :update, :destroy, :drafts]
	before_action :correct_user_lookup, only: [:edit, :update, :destroy]
	before_action :correct_user_format, only: [:new, :drafts]

	#shows all articles that current_user still own (e.g. drafts)
	#difference between this and 'users#show' is that this needs to be correct_user
	#anyone can view a user's posts that is published
	def drafts
		@user = current_user
		@drafts = @user.articles.draft_and_in_order
	end

	#show a particular post corresponding to a user
	def show
		@article = Article.find_by(id: params[:id])
		if @article.nil?
			redirect_to root_url
		else
			@user = @article.user
			@my_article = current_user?(@user)
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
				redirect_to drafts_path(current_user)
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
				redirect_to drafts_path(current_user)
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
		redirect_to drafts_path(current_user)
	end

	private 
		
		def correct_user_lookup
			@article = current_user.articles.find_by(id: params[:id])
			redirect_to root_url if @article.nil?
		end

		def correct_user_format
			user = User.find_by(id: params[:format])
			unless current_user?(user)
				redirect_to root_url
			end
		end

    def logged_in_user
        unless logged_in?
        flash[:danger] = "Please log in"
        redirect_to root_url
      end
    end

		def article_params
			params.require(:article).permit(:title, :content)
		end

end
