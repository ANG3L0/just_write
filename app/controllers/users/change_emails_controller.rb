class Users::ChangeEmailsController < ApplicationController
  def change_emails
    if logged_in?
      @user = User.find_by(id: params[:id])
    else
      flash[:danger] = "Please log in"
      redirect_to root_url
    end
  end

  def update
    if logged_in?
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
    else
      flash[:danger] = "How did you get here?"
      redirect_to root_url
    end
  end

  private

    def user_params_change_email
      params.require(:user).permit(:email, :email_confirmation)
    end

end
