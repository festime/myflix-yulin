require 'spec_helper'

feature "User registers", :js, :vcr do
  after do
    clear_email
  end

  scenario "with valid user info and valid card" do
    user_registers(user_info_state: :valid, card_state: :valid)
    expect(page).to have_content("Thank you for registering with MyFlix. Please sign in now.")
  end

  scenario "with valid user info and invalid card" do
    puts "Rails.env = #{Rails.env}"
    puts "#" * 15
    puts "ENV[STRIPE_TEST_SECRET_KEY] = #{ENV['STRIPE_TEST_SECRET_KEY']}"
    puts "ENV[STRIPE_TEST_PUBLISHABLE_KEY] = #{ENV['STRIPE_TEST_PUBLISHABLE_KEY']}"
    puts "#" * 15
    user_registers(user_info_state: :valid, card_state: :invalid)
    expect(page).to have_content("Your card number is incorrect.")
  end

  scenario "with valid user info and declined card" do
    user_registers(user_info_state: :valid, card_state: :declined)
    expect(page).to have_content("Your card was declined.")
  end

  scenario "with invalid user info and valid card" do
    puts "Rails.env = #{Rails.env}"
    puts "#" * 15
    puts "ENV[STRIPE_TEST_SECRET_KEY] = #{ENV['STRIPE_TEST_SECRET_KEY']}"
    puts "ENV[STRIPE_TEST_PUBLISHABLE_KEY] = #{ENV['STRIPE_TEST_PUBLISHABLE_KEY']}"
    puts "#" * 15
    user_registers(user_info_state: :invalid, card_state: :valid)
    expect(page).to have_content("Invalid user info, please check the error messages.")
  end

  scenario "with invalid user info and invalid card" do
    user_registers(user_info_state: :invalid, card_state: :invalid)
    expect(page).to have_content("Your card number is incorrect.")
  end

  scenario "with invalid user info and declined card" do
    user_registers(user_info_state: :invalid, card_state: :declined)
    expect(page).to have_content("Invalid user info, please check the error messages.")
  end

  def user_registers(user_info_state:, card_state:)
    set_user_inputs(user_info_state: user_info_state, card_state: card_state)

    visit register_path

    fill_in "Email Address", with: @user_params[:email]
    fill_in "Password", with: @user_params[:password]
    fill_in "Full Name", with: @user_params[:name]
    fill_in "Credit Card Number", with: @card_number
    fill_in "Security Code", with: "123"
    select "4 - April", from: "expiration[month]"
    select "2017", from: "expiration[year]"
    click_button "Sign Up"
  end

  def set_user_inputs(user_info_state:, card_state:)
    if card_state == :valid
      @card_number = "4242424242424242"
    elsif card_state == :declined
      @card_number = "4000000000000002"
    elsif card_state == :invalid
      @card_number = "4242424242424241"
    end

    @user_params = {
      name: (user_info_state == :valid ? "Yulin Chen" : " "),
      email: "yulin@example.com",
      password: "password"
    }
  end
end
