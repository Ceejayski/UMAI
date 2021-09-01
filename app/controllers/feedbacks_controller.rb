class FeedbacksController < ApplicationController
  def index
    feedbacks = Feedbacks.all
    render jsonapi: feedback, status: :ok
  end

  def create
  end
end
