class User < ActiveRecord::Base
  validates_presence_of :name, :password, :email
  validates_uniqueness_of :email

  has_secure_password
  has_many :queue_items, ->{ order("position ASC") }

  def normalize_position_of_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include? video
  end
end
