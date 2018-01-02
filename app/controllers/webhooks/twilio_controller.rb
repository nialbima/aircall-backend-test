class Webhooks::TwilioController < ApplicationController

  before_action :get_call, only: [ :handle_gather, :handle_record ]
  protect_from_forgery except: [
    :incoming_call, :handle_gather, :handle_record
  ]

  def incoming_call
    # stronger params here
    call_params = {
      twilio_sid: params['CallSid'],
      status: params['CallStatus'],
      called_number: params['Called'],
      called_country: params['CalledCountry'],
      called_zip: params['CalledZip'],
      called_city: params['CalledCity'],
      caller_number: params['Caller'],
      caller_country: params['CallerCountry'],
      caller_zip: params['CallerZip'],
      caller_city: params['CallerCity']
    }
    @call = Call.new(call_params)
    if @call.save
      response = Twilio::TwiML::VoiceResponse.new do |r|
        r.say("HEY THERE BUDDY! You've reached Nick.")
        params = {
          :num_digits => '1',
          :action => '/webhooks/twilio/handle_gather',
          :method => :get
        }
        r.gather(params) { |g| read_main_menu_options(g) }
      end
      render xml: response.to_xml
    end
  end

  def read_main_menu_options(gather_object)
    gather_object.say('Press 1 to connect.')
    gather_object.say('Press 2 to record him a message.')
    gather_object.say('Press any other key to start over.')
  end

  def handle_gather
    user_input = params['Digits']
    redirect_to action: 'incoming_call' unless ['1', '2'].include?(user_input)

    case user_input
    when '1'
      response = Twilio::TwiML::VoiceResponse.new do |r|
        r.dial(number: Credentials.phone_number)
        r.say('HAVE A GOOD DAY!')
      end
      @call.update(status: 'completed')
    when '2'
      recording_params = {
        :max_length => '60',
        :action => '/webhooks/twilio/handle_record',
        :finish_on_key => '#',
        :method => :get
      }
      response = Twilio::TwiML::VoiceResponse.new do |r|
        r.say('Record your message after the tone. Press the pound key to exit.')
        r.record(recording_params)
      end
    end
    render xml: response.to_xml
  end

  def handle_record
    @call.audio_url = params['RecordingUrl']
    if @call.save
      response = Twilio::TwiML::VoiceResponse.new do |r|
        r.say('You left him this message!')
        r.play(url: @call.audio_url)
        r.say('LATER!')
      end

      @call.update(status: 'completed')
      render xml: response.to_xml
    end
  end

  private

  def get_call
    @call = Call.where(twilio_sid: params['CallSid']).first
  end
end
