# [Aircall.io](https://aircall.io) - Backend technical test

This repo contains the code test for Nick Marshall's application to Aircall.

## Summary (from main repo)

The purpose of the test is to reproduce one Aircall feature: __call forwarding__.

Here is the story:

Your company has one main number. This number is an [IVR](https://en.wikipedia.org/wiki/Interactive_voice_response):
- If the caller presses `1`, call is forwarded to another phone number;
- If the caller presses `2`, he is able to leave a voicemail.

It's 9AM in the office and first calls are coming in!

## Notes + Deploy stuff!
- The URL is [here](https://aircall-backend-test-nialbima.herokuapp.com).
- I got a phone number from Twilio to use for the "main office number". It's (978) 705-6710.
- It's pointed at the dummy number provided in the docs.
- All my credentials stuff is run via a standard interface, except for the middleware (it was breaking rails)

## Features:
- Uses Rack middleware to avoid CSRF attacks.
- Has a playback route and provides the message for download on the front-end
- Works as specced otherwise.
- Uses the Twilio REST API post-call termination to get complete data on a call.

## TO DO:
- There's a chance I'll find a second on the bus this weekend to clean up the CSS a little bit, in which case I'll just push it to Heroku!
