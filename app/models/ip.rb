class Ip < ApplicationRecord
  belongs_to :post
  validates :ip_address, presence: true

  def self.uniq_ip
    distinct { |x| x.ip_address }
  end

  def self.ip_logins(ip)
    where(ip_address: ip).map(&:login)
  end
end
