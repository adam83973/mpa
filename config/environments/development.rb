Rails.application.configure do
  # config.to_prepare do
  #   DeviseFilters.add_filters
  # end
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Set host URL
  config.action_controller.default_url_options = { host: 'mathplus.dev' }

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  # Asset digests allow you to set farfuture HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  config.action_mailer.delivery_method = :letter_opener
  # config.action_view.raise_on_missing_translations = true


   ActionMailer::Base.smtp_settings = {
     :user_name => ENV['SENDGRID_USERNAME'],
     :password => ENV['SENDGRID_PASSWORD'],
     :domain => 'mathplusacademy.com',
     :address => 'smtp.sendgrid.net',
     :port => 587,
     :authentication => :plain,
     :enable_starttls_auto => true
   }

   config.action_mailer.default_url_options = { :host => 'mathplus.dev' }

   config.after_initialize do
     Bullet.enable = true
     Bullet.alert = false
     Bullet.bullet_logger = false
     Bullet.console = true
     Bullet.growl = false
     Bullet.rails_logger = false
     Bullet.bugsnag = false
     Bullet.airbrake = false
     Bullet.add_footer = false
   end
end
