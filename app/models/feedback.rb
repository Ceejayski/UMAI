class Feedback < ApplicationRecord
  belongs_to :owner, polymorphic: true
end
