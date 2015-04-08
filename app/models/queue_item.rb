class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates :position, numericality: { :greater_than => 0 }

  def rate
    return (review ? review.rate : nil)
  end

  def category_name
    category.name
  end

  def rate=(new_rate)
    if review
      review.update_attribute(:rate, new_rate)
    else
      new_review = Review.new(rate: new_rate, user: user, video: video)
      new_review.save(validate: false)
    end
  end

  private

    def review
      @review ||= Review.find_by(user_id: user.id, video_id: video.id)
    end
end
