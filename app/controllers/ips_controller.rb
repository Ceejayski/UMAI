class IpsController < ApplicationController
  skip_before_action :authenticate_request
  def index
    result = Ip.uniq_ip
    if result.empty?
      data = []
      result.each{|x|
        hash = {}
        hash['ip_address'] = x
        hash['logins'] = ip_logins(x)
        data << hash
      }
      render json: { 'data': data}, status: :ok
    else 
      render json: { 'data': [] }, status: :ok
    end
  end

  private
  def ip_logins(ip)
    Ip.where(ip_address: ip).map(&:login)
  end
end
