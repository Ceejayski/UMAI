class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings, dependent: :destroy, after_add: :update_average_rating, after_remove: :update_average_rating
  has_many :ips, dependent: :destroy
  has_many :feedbacks, as: :owner

  validates_presence_of :title, :content
  scope :highest_rated, -> { order(avg_ratings: :desc) }

  def update_average_rating(_rating = nil)
    s = ratings.sum(:value)
    c = ratings.count
    update_attribute(:avg_ratings, c == 0 ? 0.0 : s / c.to_f)
  end
end
