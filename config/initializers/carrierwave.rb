CarrierWave.configure do |config|
  unless Rails.env.test?
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:                ENV['AWS_REGION']
    }
  end

  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :fog
  end

  if Rails.env.production?
    config.fog_directory  = ENV['AWS_S3_BUCKET_PRODUCTION']
  elsif Rails.env.staging?
    config.fog_directory  = ENV['AWS_S3_BUCKET_STAGING']
  elsif Rails.env.development?
    config.fog_directory  = ENV['AWS_S3_BUCKET_DEVELOPMENT']
  end
end
