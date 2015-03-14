class QueueItemsController < ApplicationController
  before_action :require_sign_in

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:queue_item][:video_id])
    queue_a_video(video)
    redirect_to my_queue_path
  end

  private
    def queue_a_video(video)
      unless current_user_queued_video?(video)
        QueueItem.create(user: current_user, video: video,
                         position: new_queue_item_position)
      end
    end

    def current_user_queued_video?(video)
      current_user.queue_items.map(&:video).include? video
    end

    def new_queue_item_position
      current_user.queue_items.count + 1
    end
end
