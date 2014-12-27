class ArticlesController < ApplicationController
	before_action :correct_user, only: [:new, :create, :update, :destroy, :index]

	#shows all articles that current_user still own (e.g. drafts)
	#difference between this and 'users#show' is that this needs to be correct_user
	#anyone can view a user's posts that is published
	def index
    @user = User.find_by(id: params[:id])
		@articles = @user.articles.where(draft: true)

	end

	#show a particular post corresponding to a user
	def show
	end

	#create a new article
	def new
		@user = User.find_by(id: params[:id])
		@article = @user.articles.new
	end

	#first time editing drafts or creating a post
	#no article ID associated with this yet
	def create
		@article = current_user.articles.build(article_params)
		if @article.save
			if params[:submit] == 'Save draft' || params[:draft]
				@article.update_attribute(:draft, true)
				redirect_to root_url
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
	def edit
	end

	def update
	end

	#delete an article (draft or not)
	def destroy
	end

	private 
		
		def correct_user
			user = User.find_by(id: params[:id])
			unless current_user?(user)
				redirect_to root_url
			end
		end

		def article_params
			params.require(:article).permit(:title, :content, :draft)
		end

end
