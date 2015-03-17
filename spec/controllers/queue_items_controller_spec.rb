require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    context "when the user has signed in" do
      before { set_current_user }

      it "sets @queue_items associated with the signed in user" do
        queue_item_1 = Fabricate(:queue_item, user: current_user)
        queue_item_2 = Fabricate(:queue_item, user: current_user)
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item_1, queue_item_2])
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    context "when the user has signed in" do
      before { set_current_user }
      let(:video) { Fabricate(:video) }

      it "redirects to the my queue page" do
        post :create, queue_item: Fabricate.attributes_for(:queue_item, user: current_user, video: video)
        expect(response).to redirect_to my_queue_path
      end

      it "creates a queue item" do
        post :create, queue_item: Fabricate.attributes_for(:queue_item, user: current_user, video: video)
        expect(QueueItem.count).to eq(1)
      end

      it "creates a queue item associated with the user" do
        post :create, queue_item: Fabricate.attributes_for(:queue_item, user: current_user, video: video)
        expect(QueueItem.first.user).to eq(current_user)
      end

      it "creates a queue item associated with the video" do
        post :create, queue_item: Fabricate.attributes_for(:queue_item, user: current_user, video: video)
        expect(QueueItem.first.video).to eq(video)
      end

      it "puts the video to the last position of the user's queue" do
        2.times { Fabricate(:queue_item, user: current_user, video: Fabricate(:video)) }
        post :create, queue_item: Fabricate.attributes_for(:queue_item, user: current_user, video: video)
        queue_item = QueueItem.find_by(user: current_user, video: video)
        expect(queue_item.position).to eq(3)
      end

      it "does not put the video to the queue if the video has already been in the queue" do
        Fabricate(:queue_item, user: current_user, video: video)
        post :create, queue_item: Fabricate.attributes_for(:queue_item, user: current_user, video: video)
        expect(current_user.queue_items.count).to eq(1)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :create, queue_item: Fabricate.attributes_for(:queue_item) }
    end
  end

  describe "DELETE destroy" do
    context "when the user has signed in" do
      before { set_current_user }
      let(:video) { Fabricate(:video) }

      it "redirects to the my queue page" do
        queue_item = Fabricate(:queue_item, user: current_user, video: video)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queue item" do
        queue_item = Fabricate(:queue_item, user: current_user, video: video)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "sets success messages" do
        queue_item = Fabricate(:queue_item, user: current_user, video: video)
        delete :destroy, id: queue_item.id
        expect(flash[:success]).to_not be_nil
      end

      it "does not delete the queue item if the item is not in the user's queue" do
        another_user = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: another_user, video: video)
        delete :destroy, id: queue_item.id
        expect(queue_item.reload).to_not be_nil
      end

      it "orders the queue items by positions ASC from 1" do # 1, 2, 3, and so on
        [1, 2, 3].each do |number|
          Fabricate(:queue_item, user: current_user, video: Fabricate(:video), position: number)
        end
        delete :destroy, id: QueueItem.find_by(user_id: current_user.id, position: 2).id
        expect(current_user.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: 1 }
    end
  end

  describe "PUT update_queue_items" do
    context "when the user has signed in" do
      before { set_current_user }

      context "when the positions are valid" do
        before do
          3.times { Fabricate(:queue_item, user: current_user, video: Fabricate(:video)) }
        end

        it "redirects to the my queue page" do
          new_positions = [1, 2, 3].shuffle
          queue_items_param = current_user.queue_items.map do |queue_item|
            {id: queue_item.id, rate: queue_item.rate, position: new_positions.shift}
          end

          put :update_queue_items, queue_items: queue_items_param

          expect(response).to redirect_to my_queue_path
        end

        it "updates the positions of queue items" do
          new_positions = [1, 2, 3].shuffle
          queue_items_param = current_user.queue_items.map do |queue_item|
            {id: queue_item.id, rate: queue_item.rate, position: new_positions.shift}
          end

          put :update_queue_items, queue_items: queue_items_param

          queue_items_param.each do |param|
            expect(QueueItem.find(param[:id]).position).to eq(param[:position])
          end
        end

        it "orders the queue items by positions ASC from 1" do # 1, 2, 3, and so on; not 2, 3, 4
          new_positions = [2, 3, 4].shuffle
          queue_items_param = current_user.queue_items.map do |queue_item|
            {id: queue_item.id, rate: queue_item.rate, position: new_positions.shift}
          end

          put :update_queue_items, queue_items: queue_items_param

          expect(current_user.reload.queue_items.map(&:position)).to eq([1, 2, 3])
        end
      end

      context "when the positions are invalid" do
        let(:invalid_positions) { [[0, 1, 2], ['', 5, 6], [-1, 1, 2], ['a', 2, 3], [1, 1, 2]] }

        before do
          [1, 2, 3].each do |number|
            Fabricate(:queue_item, user: current_user, video: Fabricate(:video), position: number)
          end
        end

        it "keeps the positions of queue items unchanged" do
          invalid_positions.each do |new_positions|
            queue_items_param = current_user.queue_items.map do |queue_item|
              {id: queue_item.id, rate: queue_item.rate, position: new_positions.shift}
            end

            put :update_queue_items, queue_items: queue_items_param

            expect(QueueItem.first(3).map(&:position)).to eq([1, 2, 3])
          end
        end
      end

      it "does not update the position of other user's queue items" do
        another_user = Fabricate(:user)
        [1, 2, 3].each do |number|
          Fabricate(:queue_item, video: Fabricate(:video),
                    user: another_user, position: number)
        end
        queue_item = another_user.queue_items.first

        put :update_queue_items, queue_items: [{id: queue_item.id, rate: queue_item.rate, position: 4}]

        expect(queue_item.reload.position).to eq(1)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { put :update_queue_items, queue_items: [{}] }
    end
  end
end
