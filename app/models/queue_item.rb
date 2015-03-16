class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates :position, numericality: { :greater_than => 0 }

  def rate
    review = Review.where(user_id: user.id, video_id: video.id).first
    return (review ? review.rate : nil)
  end

  def category_name
    category.name
  end

  def rate=(new_rate)
    review = Review.find_by(user_id: user.id, video_id: video.id)
    review.update_attribute(:rate, new_rate) if review
  end
end
