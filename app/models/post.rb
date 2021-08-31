class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings, dependent: :destroy
  has_many :ips, dependent: :destroy
  has_many :feedbacks, as: :owner
  
  validates_presence_of :title, :content
  scope :recent, -> { order(created_at: :desc) }
  scope :highest_rated, -> { includes(:ratings).group('post_id').order('AVG(ratings.value) DESC') }

  def average_rating
    if ratings.size > 0
      sum = ratings.inject(0) do |x, v|
        x + v.value
        sum.to_f / ratings.size
      end
    else
      0.0
    end
  end
end
