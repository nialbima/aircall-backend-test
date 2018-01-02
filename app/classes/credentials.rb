class Credentials
  # I like isolating my credentials into a single file instead of relying exclusively
  # on secrets.yml. It also lets you return things that are safe to store in the repo
  # through the same interface as things that need to be secret, which I like.

  # It's also self-documenting. If something's missing from ENV, we can see exactly
  # where/how that's snuck in and add it with heroku config or in /etc/environment.
  def self.twilio_key
    Rails.application.secrets.twilio_api_key
  end

end
