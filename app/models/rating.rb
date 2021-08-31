class Rating < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :value, presence: true, numericality: { less_than_or_equal_to: 5, only_integer: true }
end
