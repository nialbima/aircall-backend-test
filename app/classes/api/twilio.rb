class Api::Twilio
  # This file encapsulates the Twilio API functionality. I like moving my external
  # API code into its own class, it makes debugging easier and testing cleaner.

  def self.handle_incoming_call
    return Twilio::TwiML::VoiceResponse.new do |r|
      r.say("HEY THERE BUDDY! You've reached Nick.")
      params = {
        :num_digits => '1',
        :action => '/webhooks/twilio/handle_gather',
        :method => :get
      }
      r.gather(params) { |g| read_main_menu_options(g) }
    end
  end

  def self.get_call_data(twilio_sid)
     @client = Twilio::REST::Client.new(account_sid, auth_token)
     return @client.api.calls(twilio_sid).fetch
  end

  def self.account_sid
    'AC523cb3b3f3a43dcfbd9768305d7e77a0'
    # Credentials.twilio_account_sid
  end

  def self.auth_token
    '8dfeba3af6bb5adabbc002479286bd30'
    # Credentials.twilio_auth_token
  end

  def self.gather_input(user_input)
    case user_input
    when '1'
      return dial_number
    when '2'
      return record_message
    end
  end

  # we want to see if we can pass an action to both of these methods
  # it'll need to be a TwiML verb saying 'ping this once you're done'

  # these two are our output methods.
  # we can attach actions to dial
  # so that's easy!

  # record is a little trickier.

  def self.play_recorded_message
    return Twilio::TwiML::VoiceResponse.new do |r|
      r.say('You left him this message!')
      r.play(url: @call.audio_url)
      r.say('LATER!')

      r.redirect('/webhooks/twilio/handle_call_cleanup', method: 'GET')
    end
  end

  def self.dial_number
    return Twilio::TwiML::VoiceResponse.new do |r|
      r.dial(number: Credentials.phone_number)
      r.say('HAVE A GOOD DAY!')

      r.redirect('/webhooks/twilio/handle_call_cleanup', method: 'GET')
    end
  end

  def self.record_message
    recording_params = {
      :max_length => '60',
      :action => '/webhooks/twilio/handle_play_record',
      :finish_on_key => '#',
      :method => :get
    }
    return Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Record your message after the tone. Press the pound key to exit.')
      r.record(recording_params)
    end
  end

  def self.read_main_menu_options(gather_object)
    gather_object.say('Press 1 to connect.')
    gather_object.say('Press 2 to record him a message.')
    gather_object.say('Press any other key to start over.')
  end

end
