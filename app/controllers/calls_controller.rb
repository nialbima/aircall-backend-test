class  CallsController < ApplicationController

  def index
    @calls = Call.batched_response(30).api_response

    render :index
  end
end
