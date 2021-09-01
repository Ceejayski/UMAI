class RegistrationsController < ApplicationController
  skip_before_action :authenticate_request

  def create
    user = User.new(registration_params)
    user.save!
    user.feedbacks.create()
    render jsonapi: user, status: :created
  rescue ActiveRecord::RecordInvalid
    render  jsonapi_errors: user.errors, status: :unprocessable_entity
  end

  private

  def registration_params
    params.require(:data).require(:attributes)
          .permit(:login, :password, :password_confirmation) ||
      ActionController::Parameters.new
  end
end
