class Users::ChangeEmailsController < ApplicationController
	before_action :correct_user, only: [:change_emails, :update]


  def change_emails
      @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find(params[:id])
    if user_params_change_email[:email_confirmation] == user_params_change_email[:email]
      if @user.update_attributes(email: user_params_change_email[:email])
        flash[:success] = "Email updated"
        redirect_to @user
      else
        render 'change_emails'
      end
    else
      flash.now[:danger] = "Email and email confirmation doesn't match"
      render 'change_emails'
    end
  end

  private

    def user_params_change_email
      params.require(:user).permit(:email, :email_confirmation)
    end

		def correct_user
			user = User.find_by(id: params[:id])
			redirect_to root_url unless current_user?(user)
		end

    #def logged_in_user
    #    unless logged_in?
    #    flash[:danger] = "Please log in"
    #    redirect_to root_url
    #  end
    #end

end
