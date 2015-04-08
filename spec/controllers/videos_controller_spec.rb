require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated user" do
      before { set_current_user }

      it "sets @video" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "sets @review" do
        get :show, id: Fabricate(:video).id
        expect(assigns(:review)).to be_a_new(Review)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: Fabricate(:video).id}
    end
  end

  describe "GET search" do
    context "with authenticated user" do
      before { set_current_user }

      let(:fate_stay_night) { Fabricate(:video, title: "Fate Stay Night") }
      let(:fate_zero) { Fabricate(:video, title: "Fate Zero")}

      it "sets @videos" do
        get :search, search_term: "Fate"
        expect(assigns(:videos)).to include(fate_stay_night, fate_zero)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :search, search_term: "Fate" }
    end
  end
end
