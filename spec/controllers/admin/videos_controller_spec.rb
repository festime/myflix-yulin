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
end
