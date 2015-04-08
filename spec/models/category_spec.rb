require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  # the points to think:
  # 1. the number of videos 0, 1 ~ 6, 7~
  # 2. reverse chronological order by created_at
  # So there are four indivisual cases to test
  describe "#recent_videos" do
    it "returns an empty array if the category has no videos" do
      anime = Category.create(name: "Anime")
      expect(anime.recent_videos).to eq([])
    end

    it "returns an array of all the videos if there are less than 7 videos" do
      anime = Category.create(name: "Anime")
      4.times { Video.create(title: "foo", description: "bar", category: anime) }
      expect(anime.recent_videos.count).to eq(4)
    end

    it "returns an array of 6 videos if there are more than 6 videos" do
      anime = Category.create(name: "Anime")
      7.times { Video.create(title: "foo", description: "bar", category: anime) }
      expect(anime.recent_videos.count).to eq(6)
    end

    it "returns an array of videos in reverse chronological order by created_at" do
      anime = Category.create(name: "Anime")
      (1..6).to_a.reverse.each do |number|
        Video.create(title: "foo", description: "bar",
                     category: anime, created_at: number.day.ago)
      end
      timestamps = anime.recent_videos.map(&:created_at)

      (1...timestamps.count).each do |n|
        expect(timestamps[n - 1] > timestamps[n]).to be_truthy
      end
    end

    # However, videos in the array recent_videos returns in reverse chronological order
    # doesn't guarantee the videos are the most recent
    # The additional spec is necessary
    it "returns the most recent 6 videos" do
      anime = Category.create(name: "Anime")
      6.times { Video.create(title: "foo", description: "bar", category: anime) }
      old_video = Video.create(title: "old", description: "old", category: anime, created_at: 1.day.ago)
      expect(anime.recent_videos).to_not include(old_video)
    end
  end
end
