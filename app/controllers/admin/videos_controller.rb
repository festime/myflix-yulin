class Admin::VideosController < ApplicationController
  before_action :require_sign_in
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    handel_url

    if @video.save
      flash[:success] = "You have just created a video!"
      redirect_to home_path
    else
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title,
                                  :description,
                                  :category_id,
                                  :large_cover,
                                  :small_cover,
                                  :url)
  end

  def require_admin
    unless current_user.admin?
      flash[:danger] = "You're not authorized to do that."
      redirect_to home_path
    end
  end

  def handel_url
    if params[:url] and params[:url].start_with? "http://", "https://"
      params[:url].prepend "http://"
    end
  end
end