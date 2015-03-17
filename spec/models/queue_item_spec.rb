require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).is_greater_than(0) }

  describe "#video_title" do
    it "returns the title of the video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq(video.title)
    end
  end

  describe "#rate" do
    it "returns the rate if the review is present" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, video: video, user: user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rate).to eq(review.rate)
    end

    it "returns nil if the review is not present" do
      queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: Fabricate(:video))
      expect(queue_item.rate).to be_nil
    end
  end

  describe "#category_name" do
    it "returns the name of the category" do
      category = Fabricate(:category)
      queue_item = Fabricate(:queue_item, user: Fabricate(:user),
                             video: Fabricate(:video, category: category))
      expect(queue_item.category_name).to eq(category.name)
    end
  end

  describe "#category" do
    it "returns the category of the video" do
      category = Fabricate(:category)
      queue_item = Fabricate(:queue_item, user: Fabricate(:user),
                             video: Fabricate(:video, category: category))
      expect(queue_item.category).to eq(category)
    end
  end

  describe "#rate=" do
    context "when the user has reviewed the video" do
      it "updates the rate of the review" do
        user  = Fabricate(:user)
        video = Fabricate(:video)
        review = Fabricate(:review, user: user, video: video, rate: 1)
        queue_item = Fabricate(:queue_item, user: user, video: video)
        queue_item.rate = 5
        expect(review.reload.rate).to eq(5)
      end

      it "clears the rate of the review if the empty option is selected" do
        user  = Fabricate(:user)
        video = Fabricate(:video)
        review = Fabricate(:review, user: user, video: video, rate: 1)
        queue_item = Fabricate(:queue_item, user: user, video: video)
        queue_item.rate = ""
        expect(review.reload.rate).to eq(nil)
      end
    end

    context "when the user has not reviewed the video" do
      it "creates a new review with empty content" do
        queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: Fabricate(:video))
        queue_item.rate = 5
        expect(queue_item.reload.rate).to eq(5)
      end
    end
  end
end
