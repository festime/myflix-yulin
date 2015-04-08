class Admin::VideosController < ApplicationController
  before_action :require_sign_in
  before_action :require_admin

  def new
    @video = Video.new
  end

  private

  def require_admin
    unless current_user.admin?
      flash[:danger] = "You're not authorized to do that."
      redirect_to home_path
    end
  end
end
