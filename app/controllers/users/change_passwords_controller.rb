class Users::ChangePasswordsController < ApplicationController
  def change_passwords
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
      if user_params_change_password[:password] == ""
        flash.now[:danger] = "Password is blank"
        render 'change_passwords'
      else
        if @user.update_attributes(user_params_change_password)
          flash[:success] = "Password updated"
          redirect_to @user
        else
          render 'change_passwords'
        end
      end
    else
      flash[:danger] = "How did you get here?"
      redirect_to root_url
    end
  end

  private

    def user_params_change_password
      params.require(:user).permit(:password, :password_confirmation)
    end
end
