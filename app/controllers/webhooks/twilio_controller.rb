class Webhooks::TwilioController < ApplicationController

  before_action :get_call, only: [ :handle_gather, :handle_record ]
  protect_from_forgery except: [
    :incoming_call, :handle_gather, :handle_record
  ]

  after_action :update_twilio_status

  def update_twilio_status
    @call.update_twilio_status
  end

  def incoming_call
    # stronger params here
    @call = Call.new(call_params)
    if @call.save
      response = Api::Twilio.parse_incoming_call
      render xml: response.to_xml
    end
  end

  def handle_gather
    user_input = params['Digits']
    redirect_to action: 'incoming_call' unless ['1', '2'].include?(user_input)
    response = Api::Twilio.parse_handle_gather(user_input)
    render xml: response.to_xml
  end

  def handle_record
    @call.audio_url = params['RecordingUrl']
    if @call.save
      response = Api::Twilio.parse_handle_recor
      render xml: response.to_xml
    end
  end

  private

  def get_call
    @call = Call.where(twilio_sid: params['CallSid']).first
  end

  def call_params
    params.permit()
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
  end
end
