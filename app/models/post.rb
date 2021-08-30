class Post < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :content, :ip_address
  scope :recent, -> { order(created_at: :desc) }
end
