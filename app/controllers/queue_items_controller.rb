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

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.delete if current_user.queue_items.include?(queue_item)
    flash[:success] = "You have successfully removed the video from your queue."
    redirect_to my_queue_path
  end



  def update_queue_items
    ActiveRecord::Base.transaction do
      check_positions(params[:queue_items].collect {|queue_item_param| queue_item_param[:position]})

      params[:queue_items].each do |param|
        queue_item = QueueItem.find(param[:id])

        if queue_item.user == current_user
          queue_item.update_attributes!(rate: param[:rate], position: param[:position])
        else
          raise "The queue item does not belong to the current user."
        end
      end

      current_user.queue_items.each_with_index do |queue_item, index|
        queue_item.update_attributes(position: index + 1)
      end
    end
  rescue => exception
    #p exception.message
  ensure
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

    def check_positions(positions)
      if positions.uniq.size != positions.size
        raise
      end
    end
end
