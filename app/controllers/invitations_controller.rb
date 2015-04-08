class InvitationsController < ApplicationController
  before_action :require_sign_in

  def new
    @invitation = Invitation.new
  end

  def create
    addressee = User.find_by(email: params[:invitation][:addressee_email])
    @invitation = Invitation.new(invitation_params)

    if !params[:invitation][:addressee_email].blank? && !addressee
      @invitation.save
      AppMailer.delay.send_an_invitation(@invitation)
      flash[:success] = "You successfully sent an invitation to your friend."
      redirect_to home_path
    else
      flash[:danger] = "The email address is registered or invalid."
      render :new
    end
  end

  private

  def invitation_params
    sub_params = { sender: current_user }
    params.require(:invitation).permit(:addressee_email, :addressee_name, :message).merge(sub_params)
  end
end
