# NOTES

# CORE TASK:
- we have an IVR.
  - if the caller presses 1, it's forwarded to another phone number.
    - and we'll likely need to receive a subsequent number to go to
    - this should recur here. basically, every time it gets a new phone number it's another copy.
  - if the caller presses 2, you get to leave a voicemail. this is the end of the loop.
  - THOUGHTS:
    - does it make sense to do this as a while loop?
    - this seems like a situation where Sidekiq could be useful. How many users should be part of the main app thread? probably not many!

## THINGS TO CONSIDER:
  - we only need to worry about inbound calls.
  - we need a twilio ngrok.
    - done. ngrok's in /code now.

  - no views are needed.
    - except for this thing about an "activity feed."
      - An activity feed, listing all calls, should be displayed: status of the call, duration, link to an audio file if the caller dropped a voicemail plus other info you have in mind.
      - so that's something.
  - no tests

ruby helper library: https://www.twilio.com/docs/libraries/ruby

## CONTROLLERS
- webhooks (for twilio)
- classes (for actual API responses)

## THE CALL MODEL
- has_many transfers
- DB needs:
  - opened_at/closed_at (for duration)
  - status (what statuses do we want?)
    - "user_call_succeeded"
    - "user_call_failed"
  - transfer count: the transfers made during the call.
    - created in the main event loop, only returned to the api feed.

## THE TRANSFER MODEL
- belongs to call
- transferred_from - string, just the number
- transferred_to - string, just the number
- that's it.

## DEPLOY
  - we're on heroku: aircall-backend-test-nialbima
  - we're going to need to configure ENV there, we're only using dotenv in development.
