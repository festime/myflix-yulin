class User < ActiveRecord::Base
  validates_presence_of :name, :password, :email
  validates_uniqueness_of :email

  has_secure_password
  has_many :queue_items, ->{ order("position ASC") }
  has_many :reviews, -> { order("created_at DESC") }

  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id

  def normalize_position_of_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include? video
  end

  def following?(another_user)
    Relationship.find_by(leader_id: another_user.id, follower_id: self.id)
  end

  def can_follow?(another_user)
    !self.following?(another_user) && self != another_user
  end

  def follows(another_user)
    Relationship.create(leader: another_user, follower: self) if self.can_follow?(another_user)
  end
end
