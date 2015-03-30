class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail(:to => user.email, from: "info@myflix.com", :subject => "Welcome to MyFlix!")
  end

  def send_password_reset_email(user)
    @user = user
    mail(:to => user.email, from: "infor@myflix.com", :subject => "Reset your MyFlix password")
  end
end
