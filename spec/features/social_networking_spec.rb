require 'spec_helper'

feature 'social networking' do
  scenario "User follows and unfollow someone" do
    attack_on_titan = Fabricate(:video)
    another_user = Fabricate(:user)
    Fabricate(:review, user: another_user, video: attack_on_titan)

    sign_in

    click_video_link_on_home_page(attack_on_titan)
    expect(page).to have_content(another_user.name)

    click_user_link_on_video_page(attack_on_titan, another_user)
    expect_user_page_to_have_link(another_user, 'Follow')

    click_link('Follow')
    expect(page).to have_content(another_user.name)

    visit user_path(another_user)
    expect(page).to_not have_content('Follow')

    unfollow(another_user)
    expect(page).to_not have_content(another_user.name)

    expect_user_page_to_have_link(another_user, 'Follow')
  end

  def expect_user_page_to_have_link(user, link_text)
    visit user_path(user)
    expect(page).to have_content(link_text)
  end

  def click_user_link_on_video_page(video, user)
    visit video_path(video)
    click_link(user.name)
  end

  def unfollow(user)
    visit people_path
    find(:xpath, "//tr/td[4]/a").click
  end
end
