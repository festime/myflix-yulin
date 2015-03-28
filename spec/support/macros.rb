def set_current_user
  session[:user_id] = Fabricate(:user).id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(user=nil)
  user = user || Fabricate(:user)
  visit sign_in_path
  fill_in "Email Address", with: user.email
  fill_in "Password"     , with: user.password
  click_button 'Sign in'
end

def click_video_link_on_home_page(video)
  visit home_path
  find(:xpath, "//a[@href='#{video_path(video)}']").click
end
