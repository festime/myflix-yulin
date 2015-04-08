require 'spec_helper'

describe ResetPasswordsController do
  describe "POST confirm_password_reset" do
    context "when the user has signed" do
      it "redirects to the home page" do
        set_current_user
        post :confirm_password_reset, email: Faker::Internet.email
        expect(response).to redirect_to home_path
      end
    end

    context "when the user does not sign in" do
      after { ActionMailer::Base.deliveries.clear }

      context "with blank input" do
        it "does not send an email" do
          post :confirm_password_reset, email: ""
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end

        it "redirects to the forgot password page" do
          post :confirm_password_reset, email: ""
          expect(response).to redirect_to forgot_password_path
        end

        it "shows an error message" do
          post :confirm_password_reset, email: ""
          expect(flash[:danger]).to_not be_nil
        end
      end

      context "with existing email" do
        it "sends an email to the user's address" do
          user = Fabricate(:user)
          post :confirm_password_reset, email: user.email
          expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
        end

        it "sets token to the user's record" do
          user = Fabricate(:user)
          post :confirm_password_reset, email: user.email
          expect(user.reload.token).to_not be_nil
        end
      end

      context "with non-existing email" do
        it "does not send an email" do
          post :confirm_password_reset, email: Faker::Internet.email
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end

        it "redirects to the forgot password path" do
          post :confirm_password_reset, email: Faker::Internet.email
          expect(response).to redirect_to forgot_password_path
        end

        it "shows an error message" do
          post :confirm_password_reset, email: Faker::Internet.email
          expect(flash[:danger]).to_not be_nil
        end
      end
    end
  end

  describe "GET new" do
    context "with valid token" do
      it "renders the new template" do
        user = Fabricate(:user, token: SecureRandom::urlsafe_base64)
        get :new, token: user.token
        expect(response).to render_template :new
      end

      it "sets @token" do
        user = Fabricate(:user, token: SecureRandom::urlsafe_base64)
        get :new, token: user.token
        expect(assigns(:token)).to eq(user.token)
      end
    end

    context "with invalid token" do
      it "renders the invalid token page" do
        user = Fabricate(:user)
        get :new, token: SecureRandom::urlsafe_base64
        expect(response).to render_template :invalid_token
      end
    end
  end

  describe "POST create" do
    context "with valid token" do
      it "redirects to the sign in page" do
        user = Fabricate(:user, token: SecureRandom::urlsafe_base64)
        post :create, new_password: "newpassword", token: user.token
        expect(response).to redirect_to sign_in_path
      end

      it "updates the user's password" do
        user = Fabricate(:user, token: SecureRandom::urlsafe_base64)
        post :create, new_password: "newpassword", token: user.token
        expect(user.reload.authenticate("newpassword")).to be_truthy
      end

      it "deletes the user's token" do
        user = Fabricate(:user, token: SecureRandom::urlsafe_base64)
        post :create, new_password: "newpassword", token: user.token
        expect(user.reload.token).to be_nil
      end

      it "sets success message about reseting password" do
        user = Fabricate(:user, token: SecureRandom::urlsafe_base64)
        post :create, new_password: "newpassword", token: user.token
        expect(flash[:success]).to_not be_nil
      end
    end

    context "with invalid token" do
      it "renders the invalid token page" do
        post :create, new_password: "newpassword", token: SecureRandom.urlsafe_base64
        expect(response).to render_template :invalid_token
      end
    end
  end
end
