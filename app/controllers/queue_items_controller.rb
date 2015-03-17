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
    current_user.normalize_position_of_queue_items
    redirect_to my_queue_path
  end



  def update_queue_items
    ActiveRecord::Base.transaction do
      check_uniqueness_of_new_positions
      check_ownership_of_queue_items

      params[:queue_items].each do |param|
        queue_item = QueueItem.find(param[:id])
        queue_item.update_attributes!(rate: param[:rate], position: param[:position])
      end

      current_user.normalize_position_of_queue_items
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

    def check_uniqueness_of_new_positions
      new_positions = params[:queue_items].collect {|queue_item_param| queue_item_param[:position]}
      raise if new_positions.uniq.size != new_positions.size
    end

    def check_ownership_of_queue_items
      queue_items = QueueItem.find(params[:queue_items].collect {|queue_item_param| queue_item_param[:id]})
      queue_items.each {|queue_item| raise if queue_item.user != current_user}
    end
end
