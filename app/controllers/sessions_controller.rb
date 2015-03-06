class SessionsController < ApplicationController

  def new
    redirect_to home_path if signed_in?
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to home_path, notice: "You're signed in, enjoy!"

    else
      flash[:error] = 'Your email or password is invalid.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You're signed out."
    redirect_to root_path
  end
end
