class Api::Twilio
  # This file encapsulates the Twilio API functionality. I like moving my external
  # API code into its own class, it makes debugging easier and testing cleaner.

  # This method is technically part of the same phone tree, but it uses a
  # different API to get clean data on each call.
  def self.get_call_data(twilio_sid)
     client = Twilio::REST::Client.new(account_sid, auth_token)
     return client.api.calls(twilio_sid).fetch
  end

  # The rest of this file is the actual phone tree itself.
  def self.handle_incoming_call
    return Twilio::TwiML::VoiceResponse.new do |r|
      r.say("HEY THERE BUDDY! You've reached Nick.")
      r.gather(gather_params) { |g|
        g.say('Press 1 to connect.')
        g.say('Press 2 to record him a message.')
        g.say('Press any other key to start over.')
      }
    end
  end

  def self.gather_params
    return {
      :num_digits => '1',
      :action => '/webhooks/twilio/handle_gather',
      :method => :get
    }
  end

  def self.gather_input(user_input)
    case user_input
    when '1'
      return dial_number
    when '2'
      return record_message
    end
  end

  def self.play_recorded_message(url)
    return Twilio::TwiML::VoiceResponse.new do |r|
      r.say('You left him this message!')
      r.play(url: url)
      r.say('LATER!')
    end
  end

  def self.dial_number
    return Twilio::TwiML::VoiceResponse.new do |r|
      r.dial(dial_params)
      r.say('HAVE A GOOD DAY!')
    end
  end

  def self.dial_params
    return {
      number: Credentials.phone_number
    }
  end

  def self.record_message
    return Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Record your message after the tone. Press the pound key to exit.')
      r.record(recording_params)
    end
  end

  def self.recording_params
    return {
      :max_length => '60',
      :action => '/webhooks/twilio/handle_play_record',
      :finish_on_key => '#',
      :method => :get
    }
  end

  private

  def self.account_sid
    Credentials.twilio_account_sid
  end

  def self.auth_token
    Credentials.twilio_auth_token
  end

end
