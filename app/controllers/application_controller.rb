class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    authorization_error unless @current_user
  end

  def current_page
    return 1 unless params[:page]
    return params[:page] if params[:page].is_a?(String)

    params.dig(:page, :number) if params[:page].is_a?(Hash)
  end

  def per_page
    return unless params[:page]
    return params[:per_page] if params[:per_page].is_a?(String)

    params.dig(:page, :size) if params[:page].is_a?(Hash)
  end

  def authorization_error
    errors = {
      "status" => "403",
      "source" => { "pointer" => "/headers/authorization" },
      "title" =>  "Not authorized",
      "detail" => "Can't Find post under current user"
    }
    render json: { "errors": [ errors ] }, status: 403
  end
end
