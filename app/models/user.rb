class User < ActiveRecord::Base
  validates_presence_of :name, :password, :email
  validates_uniqueness_of :email

  has_secure_password
  has_many :queue_items, ->{ order("position ASC") }
end
