require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "when the user has signed in" do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      before do
        session[:user_id] = user.id
      end

      context "with valid input" do
        before do
          post :create, { video_id: video.id, review: Fabricate.attributes_for(:review) }
        end

        it "redirects to the video page" do
          expect(response).to redirect_to video
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the signed in user" do
          expect(Review.first.user).to eq(user)
        end

        it "sets success messages" do
          expect(flash[:success]).to_not be_nil
        end
      end

      context "with invalid input" do
        before do
          post :create, { video_id: video.id, review: { rate: "", content: "" } }
        end

        it "sets @video" do
          expect(assigns(:video)).to eq(video)
        end

        it "sets @review" do
          expect(assigns(:review)).to be_a_new(Review)
        end

        it "renders videos/show template" do
          expect(response).to render_template "videos/show"
        end

        it "does not create a review" do
          expect(Review.count).to eq(0)
        end
      end
    end

    context "when the user does not sign in" do
      it "redirects to the sign in page" do
        post :create, { video_id: Fabricate(:video).id, review: { rate: "", content: "" } }
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
