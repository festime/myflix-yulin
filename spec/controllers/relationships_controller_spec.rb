require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end

    context "when the user has signed in" do
      before { set_current_user }

      it "sets @relationships to the current user's following relationships" do
        relationships = (1..3).collect { Fabricate(:relationship, follower: current_user) }
        get :index
        expect(assigns(:relationships)).to eq(relationships)
      end
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: 1 }
    end

    context "when the user has signed in" do
      before { set_current_user }

      it "redirects to the people page" do
        relationship = Fabricate(:relationship, follower: current_user)
        delete :destroy, id: relationship.id
        expect(response).to redirect_to people_path
      end

      it "deletes the relationship if the current user is the follower of the relationship" do
        relationship = Fabricate(:relationship, follower: current_user)
        delete :destroy, id: relationship.id
        expect(Relationship.count).to eq(0)
      end

      it "does not delete the relationship if the current user isn't the follower of the relationship" do
        relationship = Fabricate(:relationship, follower: Fabricate(:user))
        delete :destroy, id: relationship.id
        expect(Relationship.count).to eq(1)
      end
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    context "when the user has signed in" do
      before { set_current_user }

      it "redirects to the people page" do
        post :create, leader_id: Fabricate(:user)
        expect(response).to redirect_to people_path
      end

      it "creates a relationship that the current user follows the leader" do
        leader = Fabricate(:user)
        post :create, leader_id: leader
        expect(Relationship.first.follower).to eq(current_user)
        expect(Relationship.first.leader).to eq(leader)
      end

      it "does not create a relationship if the current user is following the leader" do
        leader = Fabricate(:user)
        Fabricate(:relationship, leader: leader, follower: current_user)
        post :create, leader_id: leader.id
        expect(Relationship.count).to eq(1)
      end

      it "does not allow one to follow themselves" do
        post :create, leader_id: current_user.id
        expect(Relationship.count).to eq(0)
      end
    end
  end
end
