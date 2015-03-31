class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :sender, class_name: "User"

  attr_accessor :addressee_name, :message
end
