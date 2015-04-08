class ReviewsController < ApplicationController
  before_action :require_sign_in

  def create
    @video = Video.find(params[:video_id])
    @review = Review.new(user: current_user, video: @video,
                         rate: params[:review][:rate],
                         content: params[:review][:content])

    if @review.save
      flash[:success] = "You have reviewed '#{@video.title}'."
      redirect_to @video
    else
      render "videos/show"
    end
  end
end
