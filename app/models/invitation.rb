class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :sender, class_name: "User"
end
