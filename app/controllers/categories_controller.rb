class CategoriesController < ApplicationController
  before_action :require_sign_in

  def show
    @category = Category.find(params[:id])
  end
end
