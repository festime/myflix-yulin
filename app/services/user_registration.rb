class UserRegistration
  attr_reader :user, :invitation_token, :stripe_token

  def initialize(user, invitation_token, stripe_token)
    @user = user
    @invitation_token = invitation_token
    @stripe_token = stripe_token
  end

  def call
    if user.valid?
      charge = credit_card_charge
      return Failure.new(charge.error_message) unless charge.successful?

      user.save
      handle_invitation
      AppMailer.delay.send_welcome_email(user)
      return Success.new("Thank you for registering with MyFlix. Please sign in now.")

    else
      return Failure.new("Invalid user info, please check the error messages.")
    end
  end

  private

    def handle_invitation
      invitation = Invitation.find_by(token: invitation_token)

      if invitation
        sender = User.find(invitation.sender_id)
        user.follows(sender)
        sender.follows(user)
        invitation.delete
      end
    end

    def credit_card_charge
      token = stripe_token
      charge = StripeWrapper::Charge.create(
        :amount => 999, # amount in cents, again
        :source => token,
        :description => "Sign up charge for #{user.email}."
      )
    end
end

class Success
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def successful?
    true
  end
end

class Failure
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def successful?
    false
  end
end
