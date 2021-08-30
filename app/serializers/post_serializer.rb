class PostSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :content, :ip_address
end
