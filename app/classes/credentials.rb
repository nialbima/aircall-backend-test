class Credentials
  # I like isolating my credentials into a single file instead of relying exclusively
  # on secrets.yml. It also lets you return things that are safe to store in the repo
  # through the same interface as things that need to be secret, which I like.

  # It's also self-documenting. If something's missing from ENV, we can see exactly
  # where/how that's snuck in and add it with heroku config or in /etc/environment.
  def self.twilio_auth_token
    '8dfeba3af6bb5adabbc002479286bd30'
    # Rails.application.secrets.twilio_auth_token
  end

  def self.twilio_account_sid
    'AC523cb3b3f3a43dcfbd9768305d7e77a0'
    # Rails.application.secrets.twilio_account_sid
  end

  def self.phone_number
    Rails.application.secrets.phone_number
  end

end
