# This lets us use a Node-like .env syntax to get our variables.
# This is also maybe the only thing I enjoy about writing Node.
require 'dotenv/load'

Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load

  config.assets.debug = true
  config.assets.quiet = true

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # We shouldn't use the credentials API I use in application code here.
  # It's better to rely on Rails application secrets in config so we don't break
  # conventions.
  twilio_auth_token = Rails.application.secrets.twilio_auth_token
  # This line lets us disable protection for Twilio's requests without exposing
  # the app to CSRF attacks.
  config.middleware.use Rack::TwilioWebhookAuthentication, twilio_auth_token, /twilio/
end
