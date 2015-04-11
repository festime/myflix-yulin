require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it_behaves_like "require admin" do
      let(:action) { get :new }
    end

    context "when the current is an administrator" do
      it "sets @video to a new Video" do
        set_admin_current_user
        get :new
        expect(assigns(:video)).to be_a_new(Video)
      end
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    it_behaves_like "require admin" do
      let(:action) { post :create }
    end

    context "when the current user is an administrator" do
      before { set_admin_current_user }

      context "with valid input" do
        after do
          delete_files_uploaded_by_tests
        end

        it "creates a video with small cover and large_cover" do
          post :create, video: Fabricate.attributes_for(:video, small_cover: fixture_file_upload('fate_stay_night.jpg'), large_cover: fixture_file_upload('fate_stay_night_large.png'))
          expect(Video.count).to eq(1)
          expect(Video.first.small_cover.file.path).to_not be_nil
          expect(Video.first.large_cover.file.path).to_not be_nil
        end

        it "redirects to the home page" do
          post :create, video: Fabricate.attributes_for(:video, small_cover: fixture_file_upload('fate_stay_night.jpg'), large_cover: fixture_file_upload('fate_stay_night_large.png'))
          expect(response).to redirect_to home_path
        end

        it "sets a success message" do
          post :create, video: Fabricate.attributes_for(:video, small_cover: fixture_file_upload('fate_stay_night.jpg'), large_cover: fixture_file_upload('fate_stay_night_large.png'))
          expect(flash[:success]).to_not be_nil
        end
      end

      context "with invalid input" do
        it "does not create a video" do
          post :create, video: Fabricate.attributes_for(:video, title: "")
          expect(Video.count).to eq(0)
        end

        it "sets @video" do
          post :create, video: Fabricate.attributes_for(:video, title: "")
          expect(assigns(:video)).to be_a(Video)
        end

        it "renders the new template" do
          post :create, video: Fabricate.attributes_for(:video, title: "")
          expect(response).to render_template :new
        end
      end
    end
  end
end
