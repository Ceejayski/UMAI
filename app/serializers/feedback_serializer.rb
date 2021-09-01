class FeedbackSerializer
  include JSONAPI::Serializer
  attributes :owner_id
  attributes :owner_type
  attributes :comment
  belongs_to :owner
  attributes :owner_feedbacks do |object|
    Feedback.where(owner_id: object.owner_id, owner_type: object.owner_type).map(&:id)
  end
end