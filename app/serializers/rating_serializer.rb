class RatingSerializer
  include JSONAPI::Serializer
  attributes :value
  has_one :post
  has_one :user
end
