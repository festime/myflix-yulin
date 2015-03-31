require 'spec_helper'

describe Invitation do
  it { should belong_to(:sender).class_name("User") }

  it_behaves_like "tokenable" do
    let(:object) { Invitation.create }
  end

  describe "#addressee_name=" do
    it "sets the addressee's name" do
      invitation = Invitation.new
      invitation.addressee_name = "Tom Riddle"
      expect(invitation.addressee_name).to eq("Tom Riddle")
    end
  end

  describe "#addressee_name" do
    it "returns the addressee's name" do
      invitation = Invitation.new(addressee_name: "Tom Riddle")
      expect(invitation.addressee_name).to eq("Tom Riddle")
    end
  end

  describe "#message=" do
    it "sets the message" do
      invitation = Invitation.new
      invitation.message = "This is an amazing website."
      expect(invitation.message).to eq( "This is an amazing website.")
    end
  end

  describe "#message" do
    it "returns the message" do
      invitation = Invitation.new(message: "Good")
      expect(invitation.message).to eq("Good")
    end
  end
end
