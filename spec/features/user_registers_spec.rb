require 'spec_helper'

feature "Register" do
  scenario "with valid user info and valid card", js: true do
    user_registers(user_info_state: :valid, card_state: :valid)
    expect(page).to have_content("Sign in")
  end

  scenario "with valid user info and invalid card", js: true do
    user_registers(user_info_state: :valid, card_state: :invalid)
    expect(page).to have_content("Your card number is incorrect.")
  end

  scenario "with valid user info and declined card", js: true do
    user_registers(user_info_state: :valid, card_state: :declined)
    expect(page).to have_content("Your card was declined.")
  end

  scenario "with invalid user info and valid card", js: true do
    user_registers(user_info_state: :invalid, card_state: :valid)
    expect(page).to have_content("can't be blank")
  end

  scenario "with invalid user info and invalid card"
  scenario "with invalid user info and declined card"

  def user_registers(user_info_state:, card_state:)
    #ignore_warning_messages_from_capybara_webkit

    set_user_inputs(user_info_state: user_info_state, card_state: card_state)

    puts "Rails.env = #{Rails.env}"
    puts "### Before: #{User.count} ###"
    visit register_path
    fill_in "Email Address", with: @user_params[:email]
    fill_in "Password", with: @user_params[:password]
    fill_in "Full Name", with: @user_params[:name]
    fill_in "Credit Card Number", with: @card_number
    fill_in "Security Code", with: "123"
    select "4 - April", from: "expiration[month]"
    select "2017", from: "expiration[year]"
    click_button "Sign Up"
    puts "### After: #{User.count} ###"
  end

  def set_user_inputs(user_info_state:, card_state:)
    if card_state == :valid
      #charge = double('charge', successful?: true)
      @card_number = "4242424242424242"
    elsif card_state == :invalid
      #charge = double('charge', successful?: false, error_message: "Your card was declined.")
      @card_number = "4000000000000002"
    elsif card_state == :declined
      @card_number = "4242424242424241"
    end
    #StripeWrapper::Charge.stub(:create).and_return(charge)

    @user_params = {
      name: (user_info_state == :valid ? "Yulin Chen" : ""),
      email: "yulin@example.com",
      password: "password"
    }
  end

  def ignore_warning_messages_from_capybara_webkit
    page.driver.allow_url("https://api.stripe.com/v1/tokens")
    page.driver.allow_url("https://js.stripe.com/v2/")
  end
end
