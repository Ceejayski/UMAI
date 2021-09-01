class PostSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :content, :avg_ratings
  has_one :user
  has_many :ip
  has_many :rating
end
