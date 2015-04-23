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

    fill_in "Password",  with: @addressee.password
    fill_in "Full Name", with: @addressee.name
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "4 - April", from: "expiration[month]"
    select "2017", from: "expiration[year]"
    click_button "Sign Up"
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
