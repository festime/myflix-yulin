require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    context "when the use has signed in" do
      let(:user) { Fabricate(:user) }

      before do
        session[:user_id] = user.id
      end

      it "sets @queue_items associated with the signed in user" do
        queue_item_1 = Fabricate(:queue_item, user: user)
        queue_item_2 = Fabricate(:queue_item, user: user)
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item_1, queue_item_2])
      end
    end

    context "when the user does not sign in" do
      it "redirects to the sign in page" do
        get :index
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
