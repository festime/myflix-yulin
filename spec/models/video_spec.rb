require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:category) }

  describe "#search_by_title" do
    it "returns an empty array if there is no match" do
      attack_on_titan = Fabricate(:video, title: "Attack On Titan")
      one_piece = Fabricate(:video, title: "One Piece")
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      attack_on_titan = Fabricate(:video, title: "Attack On Titan")
      one_piece = Fabricate(:video, title: "One Piece")
      expect(Video.search_by_title("One Piece")).to eq([one_piece])
    end

    it "returns an array of one video for a partial match" do
      attack_on_titan = Fabricate(:video, title: "Attack On Titan")
      one_piece = Fabricate(:video, title: "One Piece")
      expect(Video.search_by_title("Piece")).to eq([one_piece])
    end

    it "returns an array of all matches ordered by created_at" do
      attack_on_titan = Fabricate(:video, title: "Attack On Titan")
      one_piece = Fabricate(:video, title: "One Piece")
      expect(Video.search_by_title("On")).to eq([one_piece, attack_on_titan])
    end

    it "returns an empty array for a search with an empty string" do
      attack_on_titan = Fabricate(:video, title: "Attack On Titan")
      one_piece = Fabricate(:video, title: "One Piece")
      expect(Video.search_by_title("")).to eq([])
    end
  end
end
