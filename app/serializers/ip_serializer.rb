class IpSerializer
  include JSONAPI::Serializer
  attributes :ip_address
  attributes :login
  has_one :post
  
end
