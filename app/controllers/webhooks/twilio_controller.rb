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
        r.say("HEY THERE BUDDY!")
        params = {
          :num_digits => '1',
          :action => '/webhooks/twilio/handle_gather',
          :method => :get
        }
        r.gather(params) do |g|
          g.say("Hi, you've reached Nick.")
          g.say('Press 1 to connect.')
          g.say('Press 2 to record him a message.')
          g.say('Press any other key to start over.')
        end
      end

      render xml: r.to_s
    end
  end

  # gathers user input
  def handle_gather
    user_input = params['Digits']
    unless ['1', '2'].include?(user_input)
      redirect_to action: 'incoming_call'
    end

    response = Twilio::TwiML::VoiceResponse
    case user_input
    when '1'
      response.new do |r|
        number = Credentials.phone_number
        r.dial(number)
        # if it fails deeper in the stack, it'll come back here
        r.say('The call failed or Nick hung up. Laaaaateeeer.')
      end
    when '2'
      recording_params = {
        :max_length => '30',
        :action => '/webhooks/twilio/handle_record',
        :method => :get
      }
      response.new do |r|
        r.say('Record your message after the tone.')
        r.record(recording_params)
      end
    else
    end

    render xml: response.to_s
  end

  def handle_record
    @call.audio_link = params['RecordingUrl']
    if @call.save
      response = Twilio::TwiML::VoiceResponse.new do |r|
        audio_link = params['RecordingUrl']
        r.say('You left him this message!')
        r.play(audio_link)
        # redirect to re-record here?
        r.say('Goodbye')
      end

      render xml: response.to_s
    end

  end

  private

  def get_call
    @call = Call.where(twilio_sid: params['TwilioSid']).first
  end
end
