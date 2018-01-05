Rails.application.routes.draw do
  namespace :webhooks do
    scope '/twilio' do
      # These are posts because the output could modify the record.
      post '/incoming_call',              to: 'twilio#incoming_call'
      post '/handle_call_status',         to: 'twilio#handle_call_status'

      get '/handle_gather',               to: 'twilio#handle_gather'
      get '/handle_record',               to: 'twilio#handle_record'
      get '/handle_play_record',          to: 'twilio#handle_play_record'
    end
  end

  root to: 'calls#index'

end
