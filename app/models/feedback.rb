class Feedback < ApplicationRecord
  belongs_to :owner, polymorphic: true

  def add_feedbacks
    self.other_feedbacks = Feedback.where(owner_id: owner_id, owner_type: owner_type).map(&:id)
  end
end
