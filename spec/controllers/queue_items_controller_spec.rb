require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    context "when the user has signed in" do
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

  describe "POST create" do
    context "when the user has signed in" do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      before do
        session[:user_id] = user.id
      end

      it "redirects to the my queue page" do
        post :create, queue_item: Fabricate.attributes_for(:queue_item, user: user, video: video)
        expect(response).to redirect_to my_queue_path
      end

      it "creates a queue item" do
        post :create, queue_item: Fabricate.attributes_for(:queue_item, user: user, video: video)
        expect(QueueItem.count).to eq(1)
      end

      it "creates a queue item associated with the user" do
        post :create, queue_item: Fabricate.attributes_for(:queue_item, user: user, video: video)
        expect(QueueItem.first.user).to eq(user)
      end

      it "creates a queue item associated with the video" do
        post :create, queue_item: Fabricate.attributes_for(:queue_item, user: user, video: video)
        expect(QueueItem.first.video).to eq(video)
      end

      it "puts the video to the last position of the user's queue" do
        2.times { Fabricate(:queue_item, user: user, video: Fabricate(:video)) }
        post :create, queue_item: Fabricate.attributes_for(:queue_item, user: user, video: video)
        queue_item = QueueItem.find_by(user: user, video: video)
        expect(queue_item.position).to eq(3)
      end

      it "does not put the video to the queue if the video has already been in the queue" do
        Fabricate(:queue_item, user: user, video: video)
        post :create, queue_item: Fabricate.attributes_for(:queue_item, user: user, video: video)
        expect(user.queue_items.count).to eq(1)
      end
    end

    context "when the user does not sign in" do
      it "redirects to the sign in page" do
        post :create, queue_item: Fabricate.attributes_for(:queue_item)
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "DELETE destroy" do
    context "when the user has signed in" do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      before do
        session[:user_id] = user.id
      end

      it "redirects to the my queue page" do
        queue_item = Fabricate(:queue_item, user: user, video: video)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queue item" do
        queue_item = Fabricate(:queue_item, user: user, video: video)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "sets success messages" do
        queue_item = Fabricate(:queue_item, user: user, video: video)
        delete :destroy, id: queue_item.id
        expect(flash[:success]).to_not be_nil
      end

      it "does not delete the queue item if the item is not in the user's queue" do
        another_user = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: another_user, video: video)
        delete :destroy, id: queue_item.id
        expect(queue_item.reload).to_not be_nil
      end
    end

    context "when the user does not sign in" do
      it "redirects to the sign in page" do
        delete :destroy, id: 1
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
