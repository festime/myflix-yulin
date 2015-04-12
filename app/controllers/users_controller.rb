class UsersController < ApplicationController
  before_action :require_sign_in, only: [:show]
  before_action :reject_signed_in_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      handle_credit_card_charge
      handle_invitation

      AppMailer.delay.send_welcome_email(@user)
      redirect_to sign_in_path
    else
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

    def handle_invitation
      invitation = Invitation.find_by(token: params[:token])

      if invitation
        sender = User.find(invitation.sender_id)
        @user.follows(sender)
        sender.follows(@user)
        invitation.delete
      end
    end

    def handle_credit_card_charge
      Stripe.api_key = ENV["STRIPE_TEST_SECRET_KEY"]

      token = params[:stripeToken]

      begin
        charge = Stripe::Charge.create(
          :amount => 999, # amount in cents, again
          :currency => "usd",
          :source => token,
          :description => "Sign up charge for #{@user.email}."
        )
      rescue Stripe::CardError => e
        # The card has been declined
      end
    end
end
