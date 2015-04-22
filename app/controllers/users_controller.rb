class UsersController < ApplicationController
  before_action :require_sign_in, only: [:show]
  before_action :reject_signed_in_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    result = UserRegistration.new(@user, params[:token], params[:stripeToken]).call

    if result.successful?
      flash[:success] = result.message
      redirect_to sign_in_path

    else
      flash.now[:danger] = result.message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end



  def new_with_token
    invitation = Invitation.find_by(token: params[:token])

    if invitation
      @user = User.new(email: invitation.addressee_email)
      @token = invitation.token
      render :new
    else
      redirect_to register_path
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
