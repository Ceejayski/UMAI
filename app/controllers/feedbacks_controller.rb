class FeedbacksController < ApplicationController
  skip_before_action :authenticate_request
  def index
    feedbacks = Feedbacks.all
    render jsonapi: feedback, status: :ok
  end
end
