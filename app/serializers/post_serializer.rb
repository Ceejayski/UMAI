class PostSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :content 
  has_one :user
  has_many :ip
  has_many :rating
  attributes :avg_ratings do |object|
    object.average_rating
  end
end
