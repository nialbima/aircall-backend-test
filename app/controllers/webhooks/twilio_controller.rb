class Webhooks::TwilioController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :get_call, only: [
    :handle_gather,
    :handle_record,
    :handle_call_status
  ]

  def incoming_call
    @call = Call.new(call_params)
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

  def handle_call_status
    @call.assign_attributes(call_params)

    # This is slightly inefficient! We get most, but not all, of the necessary
    # data fields from the status callback API. Twilio's giving us some data here,
    # so we wind up overwriting status and duration.
    # There's a 1.5s discrepancy between the created_at timestamp here and
    # the start_time saved by Twilio, so I thought it'd be okay to go get the
    # absolutely-most-correct value after the fact.
    if @call.update_twilio_status
      return head 200
    end
  end

  private

  def get_call
    @call = Call.where(twilio_sid: params['CallSid']).first
  end

  def call_params
    return {
      twilio_sid: params['CallSid'],
      status: params['CallStatus'],
      duration: params['Duration'],
      called_number: params['Called'],
      called_country: params['CalledCountry'],
      called_zip: params['CalledZip'],
      called_city: params['CalledCity'],
      caller_number: params['Caller'],
      caller_country: params['CallerCountry'],
      caller_zip: params['CallerZip'],
      caller_city: params['CallerCity']
    }.compact
  end

end
