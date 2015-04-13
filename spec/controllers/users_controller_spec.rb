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
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    it "redirects to the home page when the user has signed in" do
      set_current_user
      post :create, user: Fabricate.attributes_for(:user)
      expect(response).to redirect_to home_path
    end

    context "with valid input" do
      after { ActionMailer::Base.deliveries.clear }

      let(:user_params) { Fabricate.attributes_for(:user) }

      it "creates a user" do
        post :create, user: user_params
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do
        post :create, user: user_params
        expect(response).to redirect_to sign_in_path
      end

      context "sending emails" do
        after { ActionMailer::Base.deliveries.clear }

        it "sends an email to the new user" do
          post :create, user: user_params
          expect(ActionMailer::Base.deliveries.last.to).to eq([user_params[:email]])
        end

        it "contains the right content" do
          post :create, user: user_params
          expect(ActionMailer::Base.deliveries.last.body).to include("Welcome to MyFlix, #{user_params[:name]}")
        end
      end

      context "with valid token" do
        let(:sender) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, sender: sender) }

        it "makes the addresse follow the sender" do
          post :create, user: Fabricate.attributes_for(:user, email: invitation.addressee_email), token: invitation.token

          addressee = User.find_by(email: invitation.addressee_email)
          expect(addressee.following?(sender)).to be_truthy
        end

        it "makes the sender follow the addresse" do
          post :create, user: Fabricate.attributes_for(:user, email: invitation.addressee_email), token: invitation.token

          addressee = User.find_by(email: invitation.addressee_email)
          expect(sender.following?(addressee)).to be_truthy
        end

        it "deletes the invitation in database" do
          post :create, user: Fabricate.attributes_for(:user, email: invitation.addressee_email), token: invitation.token
          expect(Invitation.count).to eq(0)
        end
      end

      context "with invalid token" do
        it "does not establish any relationships" do
          post :create, user: Fabricate.attributes_for(:user), token: "invalid_token"
          expect(Relationship.count).to eq(0)
        end
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

      it "does not send an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
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
