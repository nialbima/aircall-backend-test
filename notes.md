# NOTES

Okay, spec's done. I'm not sure what other things to add, but:
- API response formatting(strftime) in calls_controller.rb
- isolating our code in the Twilio API file would be good.
- status updates: right now, once the user hangs up, we lose track of the call. we could go grab it from Twilio to get accurate status reporting.
- better params: we're safe-ish right now, but I'd like to make it safer if we're going to expose it.
- auth: it's unsafe RN.

path is /2010-04-01/Accounts/{AccountSid}/Calls/{CallSid}


<Twilio.Api.V2010.CallInstance
account_sid: AC523cb3b3f3a43dcfbd9768305d7e77a0
annotation:  
answered_by:  
api_version: 2010-04-01
caller_name:  
date_created: 2018-01-02 21:06:24 +0000
date_updated: 2018-01-02 21:06:56 +0000
direction: inbound
duration: 22
end_time: 2018-01-02 21:06:56 +0000 
forwarded_from: +19787056710
from: +266696687
from_formatted: +266696687
group_sid:  
parent_call_sid:  
phone_number_sid: PNfd6aaf22b66f9908f47ae361555ec8cf
price: -0.0085
price_unit: USD
sid: CAeb14bcb8cfe14fd7fb80a5dbc39e6a5f
start_time: 2018-01-02 21:06:34 +0000
status: completed
subresource_uris: {"notifications"=>"/2010-04-01/Accounts/AC523cb3b3f3a43dcfbd9768305d7e77a0/Calls/CAeb14bcb8cfe14fd7fb80a5dbc39e6a5f/Notifications.json", "recordings"=>"/2010-04-01/Accounts/AC523cb3b3f3a43dcfbd9768305d7e77a0/Calls/CAeb14bcb8cfe14fd7fb80a5dbc39e6a5f/Recordings.json"}
to: +19787056710
to_formatted: (978) 705-6710
uri: /2010-04-01/Accounts/AC523cb3b3f3a43dcfbd9768305d7e77a0/Calls/CAeb14bcb8cfe14fd7fb80a5dbc39e6a5f.json>
