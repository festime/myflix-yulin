class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rate
    review = Review.where(user_id: user.id, video_id: video.id).first
    return (review ? review.rate : nil)
  end

  def category_name
    category.name
  end
end
