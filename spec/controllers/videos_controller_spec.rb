require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated user" do
      before do
        session[:user_id] = Fabricate(:user).id
      end

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

    context "wtih unauthenticated user" do
      it "redirects to the sign in page" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "GET search" do
    context "with authenticated user" do
      before do
        session[:user_id] = Fabricate(:user).id
      end

      let(:fate_stay_night) { Fabricate(:video, title: "Fate Stay Night") }
      let(:fate_zero) { Fabricate(:video, title: "Fate Zero")}

      it "sets @videos" do
        get :search, search_term: "Fate"
        expect(assigns(:videos)).to include(fate_stay_night, fate_zero)
      end
    end

    context "with unauthenticated user" do
      it "redirects to the sign in page" do
        video = Fabricate(:video)
        get :search, search_term: "Fate"
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
