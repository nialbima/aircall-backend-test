class Webhooks::TwilioController < ApplicationController
  def incoming_call
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say("HEY THERE BUDDY!")
      params = {
        :num_digits => '1',
        :action => '/webhooks/twilio/handle_gather'
        :method => :get
      }
      r.gather(params) do |g|
        g.say("You've reached #{params[:number]}")
        g.say('Press 1 to dial a different number.')
        g.say('Press 2 to record a message for #{params[:number]}.')
        g.say('Press any other key to start over.')
      end
    end
  end

  # gathers user input
  def handle_gather
    # # redirect unless params['Digits'] includes 1 or 2
    # redirect '/hello-monkey' unless ['1', '2'].include?(params['Digits'])
    response = Twilio::TwiML::VoiceResponse

    case params['Digits']
    when '1'
      # get a new number
      response.new do |r|
        r.dial(params[:new_number])
        # if it fails deeper in the stack, it'll come back here
        r.say('The call failed or the remote party hung up. LATER.')
      end
      # dial it
    when '0'
      recording_params = {
        :max_length => '30',
        :action => '/webhooks/twilio/handle_record',
        :method => :get
      }
      response.new do |r|
        r.say('Record your message after the tone.')
        r.record(recording_params)
      end
    end
  end

  def handle_record
    Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Listen to your message.')
      r.play(params['RecordingUrl'])
      # redirect to re-record here?
      r.say('Goodbye')
    end
  end
