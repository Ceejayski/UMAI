class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private
  
  def authenticate_request
    @current_user = AuthorizedApiRequest.call(request.headers).result
    render json: { error: 'Unauthorized' }, status: 401 unless @current_user
  end
end
