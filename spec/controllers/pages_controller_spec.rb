require 'spec_helper'

describe PagesController do
  describe "GET front" do
    it "redirects to the home path if the user has signed in" do
      set_current_user
      get :front
      expect(response).to redirect_to home_path
    end
  end
end
