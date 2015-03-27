require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "redirects to the home page when the user has signed in" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "sets @user to a new User when the user does not sign in" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates a user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with invalid input" do
      let(:user_params) { Fabricate.attributes_for(:user, name: "") }

      before do
        post :create, user: user_params
      end

      it "does not save @user" do
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user).name).to eq(user_params[:name])
        expect(assigns(:user).email).to eq(user_params[:email])
        expect(assigns(:user).password).to eq(user_params[:password])
      end
    end
  end

  describe "GET show" do
    context "when the user has signed in" do
      before { set_current_user }

      it "sets @user" do
        another_user = Fabricate(:user)
        get :show, id: another_user.id
        expect(assigns(:user)).to eq(another_user)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 1 }
    end
  end
end
