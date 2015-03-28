class UsersController < ApplicationController
  before_action :require_sign_in, only: [:show]

  def new
    redirect_to home_path if signed_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      AppMailer.welcome_messages(@user).deliver
      redirect_to sign_in_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
