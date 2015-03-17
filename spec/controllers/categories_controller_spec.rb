require 'spec_helper'

describe CategoriesController do
  describe "GET show" do
    context "when the user has signed in" do
      it "sets @category" do
        set_current_user
        anime = Fabricate(:category)
        get :show, id: anime.id
        expect(assigns(:category)).to eq(anime)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 1 }
    end
  end
end
