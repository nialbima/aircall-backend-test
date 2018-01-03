Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :webhooks do
    scope '/twilio' do
      post '/incoming_call',              to: 'twilio#incoming_call'
      get '/handle_gather',               to: 'twilio#handle_gather'
      get '/handle_record',               to: 'twilio#handle_record'
      get '/handle_call_cleanup',         to: 'twilio#handle_call_cleanup'
    end
  end

  root to: 'calls#index'

end
