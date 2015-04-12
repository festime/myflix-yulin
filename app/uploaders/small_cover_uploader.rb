# encoding: utf-8

class SmallCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.test?
    storage :file
  else
    storage :fog
  end

  def store_dir
    "uploads"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process resize_to_fill: [166, 236]
end
