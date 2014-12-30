class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
		@articles = @user.articles.paginate(page: params[:page], per_page: 15).published_and_in_score_order
		respond_to do |format|
			format.html
			format.js
		end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params_signup)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the sample app!"
      redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  #def change_email
  #  @user = current_user
  #end

  #def change_password
  #  @user = current_user
  #end

  #def update
  #  @user = current_user
  #  redirect_to @user
  #  if URI(request.referer).path == change_email_user_path
  #    #this should be the only place to have email confirmation being updated
  #  elsif URI(request.referer).path == change_password_user_path
  #    if @user.update_attributes(user_params_change_password)
  #      flash[:success] = "Password updated"
  #      redirect_to @user
  #    else
  #      render 'change_password'
  #    end
  #  end
  #end

  private
    
    def user_params_signup
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
