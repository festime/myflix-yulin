class ResetPasswordsController < ApplicationController
  before_action :reject_signed_in_user

  def new
    user = User.find_by(token: params[:token])

    if user
      @token = user.token
      render :new
    else
      render :invalid_token
    end
  end

  def create
    user = User.find_by(token: params[:token])

    if user
      user.update(password: params[:new_password], token: nil)
      flash[:success] = "You have successfully reset your password."
      redirect_to sign_in_path
    else
      render :invalid_token
    end
  end



  def forgot_password
  end

  def confirm_password_reset
    user = User.find_by(email: params[:email])

    if user
      user.update_attribute(:token, SecureRandom.urlsafe_base64)
      AppMailer.delay.send_password_reset_email(user)
    else
      flash[:danger] = params[:email].blank? ? "Your email is invalid." : "The email address is not registered."
      redirect_to forgot_password_path
      return
    end
  end
end
