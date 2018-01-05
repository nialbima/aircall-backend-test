class Call < ApplicationRecord
  # main class for the app

  # I typically like to use an API framework like RABL or jBuilder, but
  # it isn't necessary and I wanted to keep the display code lightweight.
  scope :batched_response, -> count { limit(count) }
  scope :api_response, -> {
    order(opened_at: :desc).select(*api_response_keys)
  }

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
    [ :status, :audio_url, :duration, :opened_at, :closed_at,
      :called_number, :caller_number, :caller_country, :called_country ]
  end

end
