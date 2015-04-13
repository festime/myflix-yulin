require 'spec_helper'

feature "User invites a friend" do
  scenario "user successfully invites a friend and invitation is accepted" do
    @sender = Fabricate(:user)
    @addressee = Fabricate.build(:user)

    sender_invites_a_friend
    friend_accepts_invitation

    sender_should_follow_addressee
    addressee_should_follow_sender

    clear_email
  end

  def sender_invites_a_friend
    sign_in(@sender)

    visit new_invitation_path
    fill_in "Friend's Name",          with: @addressee.name
    fill_in "Friend's Email Address", with: @addressee.email
    fill_in "Invitation Message",     with: Faker::Lorem.paragraph
    click_button "Send Invitation"

    sign_out(@sender)
  end

  def friend_accepts_invitation
    open_email(@addressee.email)
    expect(current_email).to have_content(@addressee.name)

    current_email.click_link "Join MyFlix"

    StripeMock.start
    fill_in "Password",  with: @addressee.password
    fill_in "Full Name", with: @addressee.name
    click_button "Sign Up"
    StripeMock.stop
  end

  def sender_should_follow_addressee
    sign_in(@addressee)
    visit people_path
    expect(page).to have_content(@sender.name)

    sign_out(@addressee)
  end

  def addressee_should_follow_sender
    sign_in(@sender)
    visit people_path
    expect(page).to have_content(@addressee.name)
  end
end
