class SessionsController < ApplicationController

  def new
    redirect_to home_path if signed_in?
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "You're signed in, enjoy!"
      redirect_to home_path

    else
      flash[:danger] = 'Your email or password is invalid.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You've signed out."
    redirect_to root_path
  end
end
