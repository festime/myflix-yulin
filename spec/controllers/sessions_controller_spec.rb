require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to the home page when the user has signed in" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "renders the new template when the user doesn't sign in" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    it "redirects to the home page when the user has signed in" do
      set_current_user
      post :create, email: "", password: ""
      expect(response).to redirect_to home_path
    end

    context "with valid credential" do
      let(:user) { Fabricate(:user) }

      before do
        post :create, email: user.email, password: user.password
      end

      it "sets session[:user_id] to the user's id" do
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to the home page" do
        expect(response).to redirect_to home_path
      end

      it "sets success messages" do
        expect(flash[:success]).to_not be_nil
      end
    end

    context "with invalid credential" do
      let(:user) { Fabricate(:user) }

      before do
        post :create, email: user.email, password: 'wrong'
      end

      it "does not set session[:user_id]" do
        expect(session[:user_id]).to be_nil
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets error messages" do
        expect(flash[:danger]).to_not be_nil
      end
    end
  end

  describe "DELETE destroy" do
    before do
      set_current_user
      delete :destroy
    end

    it "deletes session[:user_id]" do
      expect(session[:user_id]).to be_nil
    end

    it "sets success messages" do
      expect(flash[:success]).to_not be_nil
    end

    it "redirects to the root page" do
      expect(response).to redirect_to root_path
    end
  end
end
