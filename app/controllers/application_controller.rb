class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :signed_in?, :current_user

  def signed_in?
    session[:user_id]
  end

  def require_sign_in
    unless signed_in?
      flash[:danger] = "You need to sign in to continue."
      redirect_to sign_in_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end
end
