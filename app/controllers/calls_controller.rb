class  CallsController < ApplicationController

  def index
    api_calls = Call.batched_response(30).api_response

    @calls = api_calls.map do |call|
      return {
        status: call.status,
        called_number: call.called_number,
        called_country: call.called_country,
        caller_number: call.caller_number,
        caller_country: call.caller_country,
        opened: call.try(:opened_at).try(:strftime, "%H:%M:%S %D") || 'N/A',
        closed: call.try(:closed_at).try(:strftime, "%H:%M:%S %D") || 'N/A',
        duration: "#{call.duration || 0}s"
      }
    end

    render :index
  end
end
