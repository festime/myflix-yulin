require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#search_by_title" do
    it "returns an empty array if there is no match" do
      attack_on_titan = Video.create(title: "Attack On Titan", description: "Amazing!")
      one_piece = Video.create(title: "One Piece", description: "Not bad")
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      attack_on_titan = Video.create(title: "Attack On Titan", description: "Amazing!")
      one_piece = Video.create(title: "One Piece", description: "Not bad")
      expect(Video.search_by_title("One Piece")).to eq([one_piece])
    end

    it "returns an array of one video for a partial match" do
      attack_on_titan = Video.create(title: "Attack On Titan", description: "Amazing!")
      one_piece = Video.create(title: "One Piece", description: "Not bad")
      expect(Video.search_by_title("Piece")).to eq([one_piece])
    end

    it "returns an array of all matches ordered by created_at" do
      attack_on_titan = Video.create(title: "Attack On Titan", description: "Amazing!", created_at: 1.day.ago)
      one_piece = Video.create(title: "One Piece", description: "Not bad")
      expect(Video.search_by_title("On")).to eq([one_piece, attack_on_titan])
    end

    it "returns an empty array for a search with an empty string" do
      attack_on_titan = Video.create(title: "Attack On Titan", description: "Amazing!")
      one_piece = Video.create(title: "One Piece", description: "Not bad")
      expect(Video.search_by_title("")).to eq([])
    end
  end
end
