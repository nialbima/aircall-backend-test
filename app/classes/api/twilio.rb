class Api::Twilio
  # This file encapsulates the Twilio API functionality. I like moving my external
  # API code into its own class, it makes debugging easier and testing cleaner.

  def parse_incoming_call
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

  def parse_handle_record
    return Twilio::TwiML::VoiceResponse.new do |r|
      r.say('You left him this message!')
      r.play(url: @call.audio_url)
      r.say('LATER!')
    end
  end

  def parse_handle_gather(user_input)
    case user_input
    when '1'
      return Twilio::TwiML::VoiceResponse.new do |r|
        r.dial(number: Credentials.phone_number)
        r.say('HAVE A GOOD DAY!')
      end
    when '2'
      recording_params = {
        :max_length => '60',
        :action => '/webhooks/twilio/handle_record',
        :finish_on_key => '#',
        :method => :get
      }
      return Twilio::TwiML::VoiceResponse.new do |r|
        r.say('Record your message after the tone. Press the pound key to exit.')
        r.record(recording_params)
      end
    end
  end

  def read_main_menu_options(gather_object)
    gather_object.say('Press 1 to connect.')
    gather_object.say('Press 2 to record him a message.')
    gather_object.say('Press any other key to start over.')
  end

end
