# TWILIO


phone is (978) 705-6710

Okay!

this is roughly how to write our Twilio code in the controller:
```

class WebhooksController
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
end
```

this is the call resource:
- save twilio_id
- we probably want to store start_time, end_time, AND duration.
  - saves effort
- forwarded_from and to will go on the transfer model
- from is our call number
```
{
	"sid": "CAe1644a7eed5088b159577c5802d8be38",
	"date_created": "Tue, 10 Aug 2010 08:02:17 +0000",
	"date_updated": "Tue, 10 Aug 2010 08:02:47 +0000",
	"parent_call_sid": null,
	"account_sid": "AC523cb3b3f3a43dcfbd9768305d7e77a0",
	"to": "+14153855708",
	"from": "+14158141819",
	"phone_number_sid": null,
	"status": "completed",
	"start_time": "Tue, 10 Aug 2010 08:02:31 +0000",
	"end_time": "Tue, 10 Aug 2010 08:02:47 +0000",
	"duration": "16",
	"price": "-0.03000",
	"direction": "outbound-api",
	"answered_by": null,
	"api_version": "2008-08-01",
	"forwarded_from": null,
	"caller_name": null,
	"uri": "\/2010-04-01\/Accounts\/AC523cb3b3f3a43dcfbd9768305d7e77a0\/Calls\/CAe1644a7eed5088b159577c5802d8be38.json",
	"subresource_uris":{
		"notifications": "\/2010-04-01\/Accounts\/AC523cb3b3f3a43dcfbd9768305d7e77a0\/Calls\/CAe1644a7eed5088b159577c5802d8be38\/Notifications.json",
		"recordings": "\/2010-04-01\/Accounts\/AC523cb3b3f3a43dcfbd9768305d7e77a0\/Calls\/CAe1644a7eed5088b159577c5802d8be38\/Recordings.json"
	}
}
```
ForwardedFrom	is probably useful.

# Statuses:
queued -	The call is ready and waiting in line before going out.
ringing	 - The call is currently ringing.
in-progress	- The call was answered and is currently in progress.
canceled	- The call was hung up while it was queued or ringing.
completed	- The call was answered and has ended normally.
busy	- The caller received a busy signal.
failed - The call could not be completed as dialed, most likely because the phone number was non-existent.
