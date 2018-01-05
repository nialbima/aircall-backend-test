class  CallsController < ApplicationController
  # this controller returns details on a set of calls to the
  # front end.

  def index
    @calls = Call.batched_response(30)
                 .api_response
    render :index
  end
end
