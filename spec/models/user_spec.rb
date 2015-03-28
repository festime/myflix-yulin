require 'spec_helper'

describe User do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_secure_password }
  it { should have_many(:queue_items).order("position ASC") }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:leading_relationships).class_name("Relationship").with_foreign_key(:leader_id) }
  it { should have_many(:following_relationships).class_name("Relationship").with_foreign_key(:follower_id) }

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

  describe "#following?" do
    it "returns true if the user is following another user" do
      follower = Fabricate(:user)
      leader   = Fabricate(:user)
      Fabricate(:relationship, leader: leader, follower: follower)
      expect(follower.following?(leader)).to be_truthy
    end

    it "returns false if the user isn't following another user" do
      follower = Fabricate(:user)
      leader   = Fabricate(:user)
      expect(follower.following?(leader)).to be_falsey
    end
  end
end
