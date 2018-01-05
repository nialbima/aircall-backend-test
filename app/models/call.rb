class Call < ApplicationRecord
  # main class for the app

  # A couple notes on my habits when writing Ruby:
  # - I like using explicit returns because
  #   A) they're easier to parse in complex conditionals,
  #   B) C doesn't need to do as much work interpreting the instruction and
  #   C)
  # - Concision is great, but it's easier to read Rails when self.whatever declarations
  #   are also explicit.
  # - Same for .save. Unless holding onto the object for a bit is having
  #   a performance impact, I almost always split my updates/creates into .new or
  #   .assign_attributes and .save.
  # - I use a lot of methods that return single objects (an array, a hash, a parsed string).
  #   This isn't necessarily uncommon, I just tend to use it to organize complex code.
  # - I don't like adding gems unless they're absolutely necessary.

  # I typically like to use an API framework like RABL or jBuilder, but
  # it isn't necessary here and I wanted to keep the display code lightweight.
  scope :batched_response, -> count { limit(count) }
  scope :api_response, -> { order(opened_at: :desc).select(*api_response_keys) }

  def update_twilio_status
    @twilio_call = Api::Twilio.get_call_data(self.twilio_sid)
    self.assign_attributes({
      status: @twilio_call.status,
      duration: @twilio_call.duration,
      opened_at: @twilio_call.start_time,
      closed_at: @twilio_call.end_time
    })
    self.save
  end

  # I'm separating out this method because it makes using scopes clearer.
  def self.api_response_keys
    return [
      :status, :audio_url, :duration, :opened_at, :closed_at,
      :called_number, :caller_number, :caller_country, :called_country
    ]
  end

end
