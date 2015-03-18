require 'spec_helper'

describe User do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_secure_password }
  it { should have_many(:queue_items).order("position ASC") }

  describe "#queued_video?" do
    it "returns true if the user has queued the video" do
      video = Fabricate(:video)
      user  = Fabricate(:user)
      Fabricate(:queue_item, video: video, user: user)
      expect(user.queued_video?(video)).to be_truthy
    end

    it "returns false if the user does not queued the video" do
      video = Fabricate(:video)
      user  = Fabricate(:user)
      expect(user.queued_video?(video)).to be_falsey
    end
  end
end
