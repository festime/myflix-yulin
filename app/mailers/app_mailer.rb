class AppMailer < ActionMailer::Base
  default :from => "myflix@example.com"

  def welcome_messages(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to MyFlix")
  end
end
