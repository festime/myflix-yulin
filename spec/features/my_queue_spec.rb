require 'spec_helper'

feature "My Queue" do
  given(:user) { Fabricate(:user) }

  scenario "User adds a video to my queue" do
    attack_on_titan = Fabricate(:video)
    fate_zero       = Fabricate(:video)
    one_piece       = Fabricate(:video)

    sign_in(user)

    Video.all.to_enum.with_index(1) do |video, position|
      add_video_to_my_queue(video)
      expect_video_to_be_in_queue(video, position)
      expect_link_to_be_unavailable(video, "+ My Queue")
    end

    visit my_queue_path
    set_video_position(one_piece, 1)
    set_video_position(fate_zero, 2)
    set_video_position(attack_on_titan, 3)
    click_button 'Update Instant Queue'

    expect_video_position(one_piece, "1")
    expect_video_position(fate_zero, "2")
    expect_video_position(attack_on_titan, "3")
  end

  def add_video_to_my_queue(video)
    visit video_path(video)
    click_link '+ My Queue'
  end

  def expect_video_to_be_in_queue(video, i)
    visit my_queue_path
    expect(video_title_in_row(i)).to eq(video.title)
    expect(position_in_row(i)).to eq(i)
  end

  def expect_link_to_be_unavailable(video, link_text)
    visit video_path(video)
    expect(page).to_not have_content(link_text)
  end

  def set_video_position(video, new_position)
    find(:xpath, "//a[@href='#{video_path(video)}']/../../td[1]/input").set(new_position)
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//a[@href='#{video_path(video)}']/../../td[1]/input").value).to eq(position)
  end

  def position_in_row(index)
    find(:xpath, "//tr[#{index}]/td[1]/input").value.to_i
  end

  def video_title_in_row(index)
    find(:xpath, "//tr[#{index}]/td[2]/a").text
  end
end
