class QueueItemsController < ApplicationController
  before_action :require_sign_in

  def index
    @queue_items = current_user.queue_items
  end
end
