class Users::ChangePasswordsController < ApplicationController
  before_action :logged_in_user, only: [:change_passwords, :update]

  def change_passwords
    @user = User.find_by(id: params[:id])
  end

  def update
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
  end

  private

    def user_params_change_password
      params.require(:user).permit(:password, :password_confirmation)
    end

    def logged_in_user
        unless logged_in?
        flash[:danger] = "Please log in"
        redirect_to root_url
      end
    end

end
