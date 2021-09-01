class FeedbackSerializer
  include JSONAPI::Serializer
  attributes :owner_id
  attributes :owner_type
  attributes :comment
  belongs_to :owner
end