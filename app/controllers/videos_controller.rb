class VideosController < ApplicationController
  before_action :require_sign_in

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @video_decorator = VideoDecorator.new(@video)
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:search_term])
  end
end
