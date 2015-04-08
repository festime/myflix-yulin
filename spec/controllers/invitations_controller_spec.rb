require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    context "when the user has signed in" do
      before { set_current_user }

      it "sets @invitation to be a new Invitation" do
        get :new
        expect(assigns(:invitation)).to be_a_new(Invitation)
      end
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create, message: "", addressee_email: "", addressee_name: "" }
    end

    context "when the user has signed in" do
      before { set_current_user }
      after { ActionMailer::Base.deliveries.clear }

      context "with valid email address that is non-existing in database" do
        let(:invitation_params) { Fabricate.attributes_for(:invitation) }

        it "redirects to the home page" do
          post :create, invitation: invitation_params
          expect(response).to redirect_to home_path
        end

        it "creates an invitation" do
          post :create, invitation: invitation_params
          expect(Invitation.count).to eq(1)
        end

        it "creates an invitation with the sender being the current user" do
          post :create, invitation: invitation_params
          expect(Invitation.first.sender).to eq(current_user)
        end

        it "creates an invitation with a token" do
          post :create, invitation: invitation_params
          expect(Invitation.first.token).to_not be_nil
        end

        it "creates an invitation with the specified email address" do
          post :create, invitation: invitation_params
          expect(Invitation.first.addressee_email).to eq(invitation_params[:addressee_email])
        end

        it "shows a success message" do
          post :create, invitation: invitation_params
          expect(flash[:success]).to_not be_nil
        end

        it "sends an invitation email to the specified address" do
          post :create, invitation: invitation_params
          expect(ActionMailer::Base.deliveries.last.to).to eq([invitation_params[:addressee_email]])
        end
      end

      context "with invalid email address" do
        let(:user) { Fabricate(:user) }

        it "renders the new template" do
          post :create, invitation: { addressee_email: user.email }
          expect(response).to render_template :new
        end

        it "sets @invitation" do
          post :create, invitation: { addressee_email: user.email }
          expect(assigns(:invitation)).to be_a(Invitation)
        end

        it "does not create an invitation" do
          post :create, invitation: { addressee_email: user.email }
          expect(Invitation.count).to eq(0)
        end

        it "shows an error message" do
          post :create, invitation: { addressee_email: user.email }
          expect(flash[:danger]).to_not be_nil
        end

        it "does not send an email" do
          post :create, invitation: { addressee_email: user.email }
          expect(ActionMailer::Base.deliveries).to be_empty
        end
      end
    end
  end
end
