class Webhooks::TwilioController < ApplicationController

  before_action :get_call, only: [
    :handle_gather,
    :handle_record,
    :handle_call_cleanup
  ]

  protect_from_forgery except: [
    :incoming_call,
    :handle_gather,
    :handle_record,
    :handle_call_cleanup
  ]

  def incoming_call
    @call = Call.new({
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
    })

    if @call.save
      render xml: Api::Twilio.handle_incoming_call.to_xml
    end
  end

  def handle_gather
    redirect_to action: 'incoming_call' unless ['1', '2'].include?(params['Digits'])
    render xml: Api::Twilio.gather_input(params['Digits']).to_xml
  end

  def handle_play_record
    if @call.set_audio_url(params['RecordingUrl'])
      render xml: Api::Twilio.play_recorded_message.to_xml
    end
  end

  def handle_call_cleanup
    if @call.update_twilio_status
      head 200
    end
  end

  private

  def get_call
    @call = Call.where(twilio_sid: params['CallSid']).first
  end

end
