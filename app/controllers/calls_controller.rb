class  CallsController < ApplicationController
  # this controller returns details on a set of calls to the
  # front end.

  def index
    @calls = Call.limit(30).order(created_at: :desc)
    render :index
  end
end
