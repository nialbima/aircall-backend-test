require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module BackendTest4
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # This line makes sure that our API classes are always available in Rails.
    # It's also useful for organizing code that doesn't neatly map onto the MVC
    # framework. Sometimes you need to do the weird stuff, and this keeps it
    # clean.
    config.autoload_paths << "#{Rails.root}/classes"

    # # This line lets us disable protection for Twilio's requests without exposing
    # # the app to CSRF attacks.
    # config.middleware.use Rack::TwilioWebhookAuthentication, Credentials.twilio_auth_token, '/webhooks/twilio'
  end
end
