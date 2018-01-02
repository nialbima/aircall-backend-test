# NOTES

Okay, spec's done. I'm not sure what other things to add, but:
- API response formatting(strftime) in calls_controller.rb
- isolating our code in the Twilio API file would be good.
- status updates: right now, once the user hangs up, we lose track of the call. we could go grab it from Twilio to get accurate status reporting.
- better params: we're safe-ish right now, but I'd like to make it safer if we're going to expose it.
