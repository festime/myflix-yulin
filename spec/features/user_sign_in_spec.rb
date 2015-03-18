require 'spec_helper'

feature "User signs in" do
  given(:user) { Fabricate(:user) }

  scenario "Sign in with correct credentials" do
    sign_in(user)
    expect(page).to have_content user.name
  end

  scenario "Sign in with incorrect credentials" do
    visit sign_in_path
    fill_in "Email Address", with: user.email
    fill_in "Password"     , with: "wrong password"
    click_button 'Sign in'
    expect(page).to have_content "invalid"
  end
end
