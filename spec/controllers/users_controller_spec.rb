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
    it "redirects to the home page when the user has signed in" do
      set_current_user
      post :create, user: Fabricate.attributes_for(:user)
      expect(response).to redirect_to home_path
    end

    context "with valid personal info and valid card" do
      let(:user_params) { Fabricate.attributes_for(:user) }

      before do
        result = double('result', successful?: true, message: "Successful!")
        UserRegistration.any_instance.should_receive(:call).and_return(result)
        post :create, user: user_params
      end

      after { ActionMailer::Base.deliveries.clear }

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "sets flash success message" do
        expect(flash[:success]).to eq("Successful!")
      end
    end

    context "with valid personal info and declined card" do
      let(:user_params) { Fabricate.attributes_for(:user) }

      before do
        result = double('result', successful?: false, message: "Failed!")
        UserRegistration.any_instance.should_receive(:call).and_return(result)
        post :create, user: user_params
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user).name).to eq(user_params[:name])
        expect(assigns(:user).email).to eq(user_params[:email])
        expect(assigns(:user).password).to eq(user_params[:password])
      end

      it "sets flash danger message" do
        expect(flash[:danger]).to eq("Failed!")
      end
    end

    context "with invalid personal info and valid card" do
      let(:user_params) { Fabricate.attributes_for(:user, name: "") }

      before do
        result = double('result', successful?: false, message: "Failed!")
        UserRegistration.any_instance.should_receive(:call).and_return(result)
        post :create, user: user_params
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user).name).to eq(user_params[:name])
        expect(assigns(:user).email).to eq(user_params[:email])
        expect(assigns(:user).password).to eq(user_params[:password])
      end

      it "sets flash danger message" do
        expect(flash[:danger]).to eq("Failed!")
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

  context "GET new_with_token" do
    context "with invalid token" do
      it "redirects to the register page" do
        get :new_with_token, token: "invalid_token"
        expect(response).to redirect_to register_path
      end
    end

    context "with valid token" do
      it "renders the new template" do
        invitation = Fabricate(:invitation)
        get :new_with_token, token: invitation.token
        expect(response).to render_template :new
      end

      it "sets @user with the recipient's email address" do
        invitation = Fabricate(:invitation)
        get :new_with_token, token: invitation.token
        expect(assigns(:user).email).to eq(invitation.addressee_email)
      end

      it "sets @token" do
        invitation = Fabricate(:invitation)
        get :new_with_token, token: invitation.token
        expect(assigns(:token)).to eq(invitation.token)
      end
    end
  end
end
