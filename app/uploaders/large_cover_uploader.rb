# encoding: utf-8

class LargeCoverUploader < CarrierWave::Uploader::Base
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

  process resize_to_fill: [665, 375]
end
