Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.action_mailer.smtp_settings = {
    :user_name => 'user_name',
    :password => 'password',
    :address => 'mailtrap.io',
    :domain => 'mailtrap.io',
    :port => '2525',
    :authentication => :cram_md5
  }

  ActionMailer::Base.delivery_method = :smtp

  config.action_mailer.default_url_options = {:host => "myflix-yulin-staging.herokuapp.com"}
end
