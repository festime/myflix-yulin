require 'spec_helper'

feature "Administrator adds a video" do
  after do
    delete_files_uploaded_by_tests
  end

  scenario "admin successfully adds a video and regular users can watch the video" do
    administrator_adds_a_video
    regular_users_can_watch_the_video
  end

  def administrator_adds_a_video
    administrator = Fabricate(:admin)
    anime = Fabricate(:category, name: "Anime")

    sign_in(administrator)
    click_link "Add a video"

    fill_in "Title", with: "Attack On Titan"
    fill_in "Description", with: "Awesome!"
    select "Anime", from: "video[category_id]"
    attach_file("Large Cover", "#{Rails.root}/spec/support/uploads/attack_on_titan_large.jpg")
    attach_file("Small Cover", "#{Rails.root}/spec/support/uploads/attack_on_titan.jpg")
    fill_in "Video's URL", with: "http://example.com/videos/1"
    click_button "Add Video"

    sign_out
  end

  def regular_users_can_watch_the_video
    sign_in
    expect(page).to have_selector("img[@src='/test/uploads/attack_on_titan.jpg']")

    attack_on_titan = Video.first
    click_video_link_on_home_page(attack_on_titan)
    expect(page).to have_selector("img[@src='/test/uploads/attack_on_titan_large.jpg']")
    expect(page).to have_selector("a[@href='http://example.com/videos/1']")
  end
end
